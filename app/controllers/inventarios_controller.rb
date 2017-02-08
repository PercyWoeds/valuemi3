class InventariosController < ApplicationController


  def import

    @user_id= @current_user.id
     Inventario.import(params[:file])
       redirect_to root_url, notice: "Inventario importadas."
  end 


  def import2

    @user_id= @current_user.id
     Inventario.import2(params[:file])
       redirect_to root_url, notice: "Inventario importadas."
  end 

  def import3

    @user_id= @current_user.id
     Inventario.import2(params[:file])
       redirect_to root_url, notice: "Inventario importadas."
  end 
  
  
  def index
    #page = params[:page] || 1
    @inventarios = Inventario.paginate(:page => @page)
    #@inventarios = Inventario.all
  end

  def new
    # Se crea un item vacio
    @inventario = Inventario.new(:inventario_detalles_attributes => [{}])
    @almacen = Almacen.all 
  end
  
  def create
    @inventario = Inventario.new(params[:inventario])
    if @inventario.save
      flash[:notice] = "El inventario fue correctamente creado."
      redirect_to inventarios_path      
    else
      render "new"
    end
  end

  def show
    @inventario = Inventario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @inventario }
    end
  end

  def edit
    @inventario = Inventario.find(params[:id], :include => {:inventario_detalles => {:item => :unidad_medida} })
  end



  def update
    @inventario = Inventario.find(params[:id])
    if @inventario.update_attributes(params[:inventario])
      flash[:notice] = "El inventario fue correctamente actualizado."
      redirect_to inventarios_path
    else
      render :action => "edit"
    end
  end


  def do_process

    @inventario = InventarioDetalle.where(:inventario_id=>params[:id])

    for i in @inventario
        lcPrecio =i.precio_unitario
        
        product = Product.find(i.product_id)
        if product 
          product.cost = lcPrecio        
          product.save

          if i.product_id == 4242
            puts lcPrecio.to_s 
          end 
        end 
    end 

  end 

end
