class InventariosController < ApplicationController


  def import

    @user_id= @current_user.id
     Inventario.import(params[:file])
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

        product = Product.find(i.product_id)
        product.cost = i.precio_unitario
        product.save

    end 

  end 
end
