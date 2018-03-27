class Ventaislas::VentaislaDetailsController < ApplicationController
    
  before_action :set_ventaisla 
  before_action :set_ventaisla_detail, except: [:new, :create]
  
  
  # GET /ventaisla_details
  # GET /ventaisla_details.json
  def index
    @ventaisla_details = VentaislaDetail.all
  end

  # GET /ventaisla_details/1
  # GET /ventaisla_details/1.json
  def show
  end

  # GET /ventaisla_details/new
  def new
    @ventaisla_detail = VentaislaDetail.new
    @employee = Employee.all.order(:full_name).where(active:"1")
    @valor = Valor.all
    @ventaisla_detail[:le_an_gln] = 0
    
    
  end

  # GET /ventaisla_details/1/edit
  def edit
    @employee = Employee.all 
    @valor = Valor.all
  end

  # POST /ventaisla_details
  # POST /ventaisla_details.json
  def create
    
    @ventaisla_detail = VentaislaDetail.new(ventaisla_detail_params)
    
    @ventaisla_detail.ventaisla_id  = @ventaisla.id
    
    @ventaisla_detail.le_an_gln  = params[:ac_le_an_gln]
    @ventaisla_detail.price  = params[:ac_product_price]
    
    if @ventaisla_detail.le_ac_gln < 0.01
          @ventaisla_detail.le_ac_gln = @ventaisla_detail.le_an_gln
    end      
          
          @cantidad =  @ventaisla_detail.le_an_gln -  @ventaisla_detail.le_ac_gln
          
           @ventaisla_detail[:quantity] = @cantidad.round(3)
           @total =   @ventaisla_detail[:quantity] *  @ventaisla_detail[:price] 
           @ventaisla_detail[:total]   = @total.round(2)
          
    
    @employee = Employee.all 
    @valor = Valor.all
    
     $lcpump_id = @ventaisla_detail.pump_id
     
     $lc_lectura = @ventaisla_detail.le_ac_gln
     
    respond_to do |format|
      if @ventaisla_detail.save
        
         
         $lcGalones = @ventaisla.get_importe_1("galones")
         $lcImporte = @ventaisla.get_importe_1("total")
         puts "-------------------"
         puts $lcGalones
         puts $lcImporte
         @ventaisla.update_attributes(galones:  $lcGalones ,importe: $lcImporte )
         
         @pump = Pump.find($lcpump_id)
         if @pump != nil
          @pump.update_attributes(le_an_gln: $lc_lectura)
         end 
         
              format.html { redirect_to @ventaisla, notice: 'Ventaisla detail was successfully created.' }
        format.json { render :show, status: :created, location: @ventaisla }
      else
        format.html { render :new }
        format.json { render json: @ventaisla.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ventaisla_details/1
  # PATCH/PUT /ventaisla_details/1.json
  def update
    @employee = Employee.all 
    @valor = Valor.all
    
    respond_to do |format|
      if @ventaisla_detail.update(ventaisla_detail_params)
        format.html { redirect_to @ventaisla, notice: 'Ventaisla detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @ventaisla }
      else
        format.html { render :edit }
        format.json { render json: @ventaisla.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ventaisla_details/1
  # DELETE /ventaisla_details/1.json
  def destroy
    @ventaisla_detail.destroy
       
    respond_to do |format|
      format.html { redirect_to ventaislas_url, notice: 'Ventaisla detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def set_ventaisla 
      @ventaisla = Ventaisla.find(params[:ventaisla_id])
      
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_ventaisla_detail
      @ventaisla_detail = VentaislaDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ventaisla_detail_params
      params.require(:ventaisla_detail).permit(:pump_id,:le_an_gln,:le_ac_gln,:price,:quantity,:total,:ventaisla_id,:product_id)
    end
end

    
