class DepositosController < ApplicationController
  before_action :set_deposito, only: [:show, :edit, :update, :destroy]

  # GET /depositos
  # GET /depositos.json
  def index
    @depositos = Deposito.all.paginate(:page => params[:page], :per_page => 20)
    
    
  end

  # GET /depositos/1
  # GET /depositos/1.json
  def show
    @company = Company.find(1)
    
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()

  end

  # GET /depositos/new
  def new
    
    
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    @deposito = Deposito.new
    @deposito[:code]="#{generate_guid16()}"  
    @deposito[:processed] = false
      
    @company = Company.find(1)
    @deposito.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @customers = @company.get_customers()
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()
    @concepts = Concept.all 

    @ac_user = getUsername()
    @deposito[:user_id] = getUserId()
    @deposito[:fecha1] = Date.today
    @deposito[:total] = 0.00
  end

  # GET /depositos/1/edit
  def edit
     @pagetitle = "Edit customerpayment"
    @action_txt = "Update..."
    
    @deposito = Deposito.find(params[:id])
    @company = @deposito.company
    #@ac_customer = @deposito.customer.name
    @ac_user = @deposito.user.username
    @customers = @company.get_customers()
    @servicebuys  = @company.get_servicebuys()
    @payments = @company.get_payments()
    @monedas  = @company.get_monedas()
    @bank_acounts = @company.get_bank_acounts()        
    @documents  = @company.get_documents()
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /depositos
  # POST /depositos.json
  def create
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"

    
    @deposito = Deposito.new(deposito_params)
    @company = Company.find(params[:deposito][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @customers = @company.get_customers()
    @bank_acounts = @company.get_bank_acounts()        
    @monedas  = @company.get_monedas()
    @documents  = @company.get_documents()
    @concepts = Concept.all 

    @deposito.processed='1'
        
    @deposito.user_id = @current_user.id 
    @deposito.company_id = 1
    @deposito.location_id = 1
    @deposito.division_id = 1
    

    respond_to do |format|
      if @deposito.save
          @deposito.process()
         @deposito.correlativo()       
        format.html { redirect_to @deposito, notice: 'Deposito was successfully created.' }
        format.json { render :show, status: :created, location: @deposito }
      else
        format.html { render :new }
        format.json { render json: @deposito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /depositos/1
  # PATCH/PUT /depositos/1.json
  def update
    respond_to do |format|
      if @deposito.update(deposito_params)
        format.html { redirect_to @deposito, notice: 'Deposito was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposito }
      else
        format.html { render :edit }
        format.json { render json: @deposito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /depositos/1
  # DELETE /depositos/1.json
  def destroy
    @deposito.destroy
    respond_to do |format|
      format.html { redirect_to depositos_url, notice: 'Deposito was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposito
      @deposito = Deposito.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deposito_params
      params.require(:deposito).permit(:company_id, :location_id, :division_id, :bank_account_id, :document_id, 
        :documento, :customer_id, :tm, :total, :fecha1, :fecha2, :nrooperacion, :descrip, :comments,
         :user_id, :processed, :date_processed, :code, :bank_acount_id, :concept_id, :compen,:fecha_parte)
    end
end
