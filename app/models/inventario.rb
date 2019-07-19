class Inventario < ActiveRecord::Base
  # Callbacks, son metodos que llaman a funciones cuando se realiza alguna de las acciones
  # descritas en el modelo ej: before_save (Antes de salvar), after_create (Despues de crear)
  self.per_page = 20
  
  before_create :adicionar_fecha

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
                @cantidad = row['cantidad'].to_f         

                @inv = InventarioDetalle.find_by(:product_id=>product_id)

            if @inv

            @inv.cantidad = @cantidad 
            @inv.save 

      
            else 
              puts row['code']

#                b = Product.new(:name=>row['descrip'], :company_id=> 1 ,:products_category_id=>1,
#                 :code=>row['code'],:tax1=> 18,:tax2=>0,:tax3=>0,:tax1_name=>"",:tax2_name=>"",
 #                 :tax3_name=>"")
 #               b.save
 #               @product = Product.find_by(:code=>row['code'])
 #               product_id = @product.id
            end                   

          end
      end 

  end      

  def self.import2(file)

      CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|

       @product = Product.find_by(:code=>row['code'] )

        if @product 
            @product.unidad    = row['unidad']  
            @product.ubicacion = row['ubica']  
            @product.cost      = row['price']  
            
            @product.company_id=1          
            @product.products_category_id=1
            @product.tax1=18.00
            @product.tax2=0
            @product.tax3=0            
            @product.save
            
        end 

      end 
      
  end      

  def self.import3(file)

      CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|            

      @product = Product.find_by(:code=>row['code'] )
       
        if @product                       
          #@product.name  = row['descrip']
          #@product.unidad  = row['unidad']
          cate   = row['category']
            a =  ProductsCategory.find_by(:code => cate)
            
          @product.company_id=1          
          lccategory = 1  
          if a 
            @product.products_category_id=a.id 
            lccategory= a.id 
          end 

          costo =row['costo']

          #b = OutputDetail.where(:product_id=>@product.id).update_all(:price=>costo)          

          @product.tax1=18.00
          @product.tax2=0
          @product.tax3=0
        
          @product.save 
        else 
          b = Product.new(:name=>row['descrip'], :company_id=> 1 ,:products_category_id=>lccategory ,
          :code=>row['code'],:tax1=> 18,:tax2=>0,:tax3=>0,:tax1_name=>"",:tax2_name=>"",
          :tax3_name=>"",:unidad=>row['unidad'])
          b.save                            
        end 

      

        
      end 
        
  end      

  def self.import4
  
      @ing = Purchase.all 

     for ing in @ing
        $lcFecha = ing.date1
        $lcmoneda = ing.moneda_id
        @ingdetail=  PurchaseDetail.where(:purchase_id=>ing.id)
    
        for detail in @ingdetail 
                  puts detail.code
          if $lcmoneda == 2
              costo = detail.price_without_tax  
          else
             dolar = Tipocambio.find_by('dia = ?',$lcFecha)
             if dolar 
               costo = detail.price_without_tax * dolar.compra  
             else 
               costo = detail.price_without_tax  
             end 
          end
        
          b = OutputDetail.where(:product_id=>detail.product.id).update_all(:price=>costo)          
                

        end 
     end 

        
  end      
  


  protected

  # Adiciona la fecha al registro
  def adicionar_fecha
    self.fecha = DateTime.now
  end

  # Metodo que ca lcula el total de los detalles en este caso (inventario_detalles) antes de salvar
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

