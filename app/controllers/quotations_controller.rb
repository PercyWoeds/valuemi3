class QuotationsController < ApplicationController
  before_action :set_quotation, only: [:show, :edit, :update, :destroy]

  # GET /quotations
  # GET /quotations.json
  def index


    @quotations = Quotation.all

    @locations = Location.all
    @divisions = Division.all
    @puntos =Punto.all
    @customers = Customer.all.order(:name)


  end

  # GET /quotations/1
  # GET /quotations/1.json
  def show

    @quotations = Quotation.find(params[:id])
    @locations = Location.find(@quotations.location_id)
    @divisions = Division.find(@quotations.division_id)
    @customers = Customer.find(@quotations.customer_id)
    @puntos = Punto.find(@quotations.punto_id)  

    

  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new
    @locations = Location.all
    @divisions = Division.all
    @puntos = Punto.all
    @customers = Customer.all.order(:name)
    @quotation[:code]="#{generate_guid7()}"
    @employees = Employee.all.order(:full_name)    
    @instruccions = Instruccion.find(2)

    @quotation[:condiciones] = @instruccions.description1
    @quotation[:respon] = @instruccions.description2
    @quotation[:seguro] = @instruccions.description3


  end

  # GET /quotations/1/edit
  def edit
    @locations = Location.all
    @divisions = Division.all
    @puntos = Punto.all
    @customers = Customer.all.order(:name)
    
    @employees = Employee.all.order(:full_name)    
  
  end

  # POST /quotations
  # POST /quotations.json
  def create
    @quotation = Quotation.new(quotation_params)
    @locations = Location.all
    @divisions = Division.all
    @puntos =Punto.all
    @customers = Customer.all.order(:name)
    @employees = Employee.all.order(:full_name)    
  

    respond_to do |format|
      if @quotation.save
         @quotation.correlativo

        format.html { redirect_to @quotation, notice: 'Quotation was successfully created.' }
        format.json { render :show, status: :created, location: @quotation }
      else
        format.html { render :new }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/1
  # PATCH/PUT /quotations/1.json
  def update
    @locations = Location.all
    @divisions = Division.all
    @puntos =Punto.all
    @customers = Customer.all.order(:name)
    @employees = Employee.all.order(:full_name)    

    respond_to do |format|
      if @quotation.update(quotation_params)
        format.html { redirect_to @quotation, notice: 'Quotation was successfully updated.' }
        format.json { render :show, status: :ok, location: @quotation }
      else
        format.html { render :edit }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/1
  # DELETE /quotations/1.json
  def destroy
    @quotation.destroy
    respond_to do |format|
      format.html { redirect_to quotations_url, notice: 'Quotation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quotation_params
      params.require(:quotation).permit(:fecha1, :code, :customer_id, :punto_id, :carga, :tipo_unidad, :importe, :condiciones, :respon, :seguro, :firma_id, :company_id, :location_id, :division_id)
    end
end 
