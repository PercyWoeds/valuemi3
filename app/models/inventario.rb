class Inventario < ActiveRecord::Base
  # Callbacks, son metodos que llaman a funciones cuando se realiza alguna de las acciones
  # descritas en el modelo ej: before_save (Antes de salvar), after_create (Despues de crear)
  before_create :adicionar_fecha
  before_save :adicionar_total
  before_save :actualizar_inventario
  before_destroy :marcar_destroy
  #after_destroy :actualizar_inventario

  # Relaciones
  has_many :inventario_detalles, :dependent => :destroy, :class_name => "InventarioDetalle"
  belongs_to :almacen
  
  #default_scope :order => "fecha DESC"

  # Nested Forms, son atrbutos detalle en un formulario, en este caso allow_destroy => true
  # hara que se borren todos los items relacionados
  accepts_nested_attributes_for :inventario_detalles, :allow_destroy => true#, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

 
  # validaciones
  validates_associated :almacen
  validates_presence_of :almacen_id


  # Atributos protegidos que no pueden ser modificados por los parametros

 
  # paginacion
  cattr_reader :per_page
  @@per_page = 9
  
  def self.import(file)


          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|

           @product = Product.find_by(:code=>row['code'] )

            if @product 
                product_id = @product.id  
            else 
                b = Product.new(:name=>row['descrip'], :company_id=> 1 ,:products_category_id=>1,
                  :code=>row['code'],:tax1=> 18,:tax2=>0,:tax3=>0,:tax1_name=>"",:tax2_name=>"",
                  :tax3_name=>"")
                b.save
                @product = Product.find_by(:code=>row['code'])
                product_id = @product.id
            end 

            puts row['code']
            puts row['cantidad']
            puts row['precio_unitario']

            @cantidad = row['cantidad'].to_i
            
           a = InventarioDetalle.new(:inventario_id=>1,:cantidad=>row['cantidad'].to_i,
             :precio_unitario=> row['precio_unitario'].to_f.round(2),:activo=> true,:product_id=> product_id,
              :item_id=> product_id)
           a.save            

#actualiza stock
         stock_product =  Stock.find_by(:product_id => @product.id)

        if stock_product 
           $last_stock = stock_product.quantity + @cantidad
           stock_product.unitary_cost = row['precio_unitario'].to_f.round(2)
           stock_product.quantity = $last_stock

        else
          $last_stock = 0
          stock_product= Stock.new(:store_id=>1,:state=>"Lima",:unitary_cost=> row['precio_unitario'].to_f.round(2),
          :quantity=> @cantidad ,:minimum=>0,:user_id=>@user_id,:product_id=>@product.id,
          :document_id=>1,:documento=>"INVENTARIO")           
        end 

        if stock_product.save

           @movement = MovementDetail.where(:product_id=>@product.id).last   
            if @movement  

              stock_final_value = @movement.stock_final +  @cantidad
              $stock_inicial = @movement.stock_final 

            else
              $stock_inicial = 0
              stock_final_value = 0            
            end             

           new_movement = MovementDetail.new(:product_id=> @product.id,:quantity=>  @cantidad,
            :price=> row['precio_unitario'].to_f,:balance=>$last_stock,:original_price=>row['precio_unitario'].to_f,
            :stock_inicial=>$stock_inicial ,:ingreso=>@cantidad,:salida=>0,
            :stock_final=> stock_final_value,:fecha=>"2016-12-31 00:00:00",:user_id=>@user_id)  
           new_movement.save

        end
        
        
      


        end
  end      

  def self.import2(file)


          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|

           @product = Product.find_by(:code=>row['code'] )

            if @product 
                @product.unidad    = row['unidad']  
                @product.ubicacion = row['ubica']  
                @product.save
                
            end 
          end 
        
  end      

  protected

  # Adiciona la fecha al registro
  def adicionar_fecha
    self.fecha = DateTime.now
  end

  # Metodo que calcula el total de los detalles en este caso (inventario_detalles) antes de salvar
  # Ver arriba accepts_nested_attributes_for
  def adicionar_total
    sum = 0
    inventario_detalles.each do |v|
      begin
        unless v.marked_for_destruction?
          sum += v.precio_unitario * v.cantidad
        end
      rescue
      end
    end
    self.total = sum
  end

  # Metodo que marca todos los items que deben ser eliminados
  # debido a que el maestro sera eliminado
  def marcar_destroy
    attrs = []
    inventario_detalles.each do |v|
      attrs << {:id => v.id,:_delete => true}
    end
    inventario_detalles_attributes = attrs
    actualizar_inventario
  end

  # metodo para poder actualizar el valor y el total que hay en inventarios
  def actualizar_inventario
    # Incio de una transaccion para poder asegurar que los datos
    # son almacenados correctamente
    inventario_detalles.each do |inv|
      # Este metodo de busqueda es creado automaticamente por Rails
      # a este tipo de metodos generados se llama metaprogramacion
      stock = Stock.find_by_almacen_id_and_item_id( almacen_id, inv.item_id )
      # Crear un stock vacio si retorna stock Nulo nil
      stock = Stock.new(:almacen_id => almacen_id, :cantidad => 0, :valor_inventario => 0) if stock.nil?
      # En este caso permite llamar a una funcion determinada de acurdo a la
      # operacion, permite que el codigo se mas claro
      case true
        when inv.marked_for_destruction?
          cantidad, valor =  actualizar_inventario_delete(inv, stock)
        when inv.new_record?
          cantidad, valor =  actualizar_inventario_create(inv, stock)
        else
          cantidad, valor = actualizar_inventario_update(inv, stock)
      end
      # Aqui es donde se crea el nuevo registro de stock
      Stock.create(:almacen_id => almacen_id, :valor_inventario => valor, :item_id => inv.item_id,
          :cantidad => cantidad, :activo => true, :estado => '' )
      # se marca como inactivo el ultimo
      stock.activo = false
      stock.save unless stock.id.nil?

    end

  end

protected
  # Funcion que realiza las operaciones par poder actualizar los totales dependiente de actualizar_inventario
  def actualizar_inventario_delete(inv, stock)
    cantidad = stock.cantidad - inv.cantidad
    valor = stock.valor_inventario - inv.precio_unitario * inv.cantidad
    [cantidad, valor]
  end

  # Funcion que realiza las operaciones par poder actualizar los totales dependiente de actualizar_inventario
  # En este caso es necesario revisar en la base de datos cual es su estado actual ya que
  # el objeto inv es atualizado por los nuevos valores que ingresa el usuario
  def actualizar_inventario_update(inv, stock)
    # Valor que se encuentra almacenado en la Base de Datos
    db_inv = InventarioDetalle.find(inv.id)
    cantidad = inv.cantidad + stock.cantidad - db_inv.cantidad
    valor =  inv.cantidad * inv.precio_unitario + stock.valor_inventario - (db_inv.cantidad * db_inv.precio_unitario)
    [cantidad, valor]
  end

  # Funcion que realiza las operaciones par poder actualizar los totales dependiente de actualizar_inventario
  def actualizar_inventario_create(inv, stock)
    cantidad = stock.cantidad + inv.cantidad
    valor = stock.valor_inventario + inv.cantidad * inv.precio_unitario 
    [cantidad, valor]
  end

end

