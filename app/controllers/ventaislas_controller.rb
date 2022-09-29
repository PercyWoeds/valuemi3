class VentaislasController < ApplicationController
  
  before_action :set_ventaisla, only: [:show, :edit, :update, :destroy] 

  # GET /ventaislas
  # GET /ventaislas.json
  def index
       @company= Company.find(1)
    @ventaislas = Ventaisla.order('fecha DESC,turno').paginate(:page => params[:page], :per_page => 20)
    

  end

  # GET /ventaislas/1
  # GET /ventaislas/1.json
  def show


    @ventaisla_details= @ventaisla.ventaisla_details

    @employees = Employee.all
    @islas = Island.all
    @pumps = Pump.where(island_id: @ventaisla.island_id).order(:id_surtidor,:id_posicion_manguera)
    @isla_id = @ventaisla.island_id
    @ventaisla_id = @ventaisla.id


    @valor =[]

    

    
  end

  # GET /ventaislas/new
  def new
    @company= Company.find(1)
    @ventaisla = Ventaisla.new
    @employees = @company.get_employees
    @islas = Island.all
    @ventaisla[:fecha]= Date.today
    @ventaisla[:galones] = 0 
    @ventaisla[:importe] = 0 
    @ventaisla[:tipo] = 2 

  end


def new2
    @pagetitle = "Nuevo Viatico"
    @action_txt = "Create"
    
    @ventaisla = Ventaisla.new
    @cajas = Caja.all 
    @company = Company.find(params[:company_id])
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
   @employees = @company.get_employees
    @islas = Island.all
    @ventaisla[:fecha]= Date.today
    @ventaisla[:galones] = 0 
    @ventaisla[:importe] = 0 

    @ventaisla[:tipo] = 1
  
  end

  # GET /ventaislas/1/edit
  def edit
    @employees = Employee.all
    @islas = Island.all
  end

  # POST /ventaislas
  # POST /ventaislas.json
  def create
    @ventaisla = Ventaisla.new(ventaisla_params)

    @ventaisla[:island_id] = params[:island_id]
      @islas = Island.all

    if   params[:island_id] == "3"
        @ventaisla[:tipo] =  1
    else 
        @ventaisla[:tipo] =  2

    end 
    
   @employees = Employee.all 


   
    respond_to do |format|
      if @ventaisla.save
        format.html { redirect_to @ventaisla, notice: 'Ventaisla was successfully created.' }
        format.json { render :show, status: :created, location: @ventaisla }
      else
        format.html { render :new }
        format.json { render json: @ventaisla.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ventaislas/1
  # PATCH/PUT /ventaislas/1.json
  def update
   
    
    respond_to do |format|
      if @ventaisla.update(ventaisla_params)
        format.html { redirect_to @ventaisla, notice: 'Ventaisla was successfully updated.' }
        format.json { render :show, status: :ok, location: @ventaisla }
      else
        format.html { render :edit }
        format.json { render json: @ventaisla.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ventaislas/1
  # DELETE /ventaislas/1.json
  def destroy
    @ventaisla.destroy
    respond_to do |format|
      format.html { redirect_to ventaislas_url, notice: 'Ventaisla was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

 def update_surtidores
    # updates songs based on artist selected
     @surtidores = Pump.find(params[:island_id])
     
  end
  
  def ac_mangueras
    @pumps = Pump.where([" (fuel iLIKE ?  ) ", "%" + params[:q] + "%" ])
    
    render :layout => false
  end
  
  def import
      Ventaisla.import(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 

  def import2
      Ventaisla.import2(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 
  def import3
      Ventaisla.import3(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 
  def import4
      Ventaisla.import4(params[:file])
      redirect_to root_url, notice: "Ventas importadas."
  end 
  def do_grabar 

    isla_id = params[:isla_id]
    ventaisla_id = params[:ventaisla_id]
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0
    qty = 0 
    total_qty   = 0

    totales_qty = 0
    totales_gln = 0

    if  VentaislaDetail.where(ventaisla_id: ventaisla_id).exists?

              a = VentaislaDetail.where(ventaisla_id: ventaisla_id).delete_all 
              
         end 


    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        campo_ent      = parts[0]
        campo_ent_val  = parts[1]
        campo_sal      = parts[2]
        campo_sal_val  = parts[3]
        campo_pre      = parts[4]
        campo_pre_val  = parts[5]

        puts isla_id
        puts campo_ent 
        puts campo_ent_val

        puts campo_sal 
        puts campo_sal_val

        puts campo_pre 
        puts campo_pre_val

        puts campo_ent[8.12]
         @datospump = Pump.find_by(fuel: campo_ent[8..12])
         @datospump.le_an_gln= parts[3].to_f
         @datospump.save 

         qty = parts[3].to_f - parts[1].to_f
         total_qty = parts[5].to_f * qty 

         
         

         ventaisladetalle = VentaislaDetail.new(pump_id: @datospump.id, le_an_gln: parts[1].to_f , le_ac_gln: parts[3].to_f, 
          price: parts[5].to_f, 
          quantity: qty , total: total_qty, ventaisla_id:  ventaisla_id, product_id: @datospump.product_id)

         ventaisladetalle.save

         totales_qty += total_qty
         totales_gln += qty 
        

      end
      
      i += 1
   end

       ventaislacab = Ventaisla.find(ventaisla_id)
       ventaislacab.update_attributes(importe: totales_qty , galones: totales_gln )
      # render :layout => false
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ventaisla
      @ventaisla = Ventaisla.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ventaisla_params
      params.require(:ventaisla).permit(:fecha, :turno, :employee_id, :pump_id, :importe, :le_an_gln,
       :le_ac_gln, :galones, :precio_ven,:island_id,:tipo)
    end
end
