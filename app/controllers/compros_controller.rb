include UsersHelper
include CompaniesHelper


class ComprosController < ApplicationController
  before_filter :authenticate_user!, :checkCompanies

  def import
      Compro.import(params[:file])
       redirect_to root_url, notice: "Compro  importadas."
  end 
  

  # Show compros for a company
  def list_compros
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - compros"
  
    if(@company.can_view(current_user))
     if(params[:search] and params[:search] != "")                     
        
        @compros = Compro.where(["company_id = ? and (detalle  LIKE ? OR code LIKE ?)", @company.id,"%" + params[:search] + "%", "%" + params[:search] + "%"]).order('code').paginate(:page => params[:page]) 
      else
        @compros = Compro.where(company_id: @company.id).order('code').paginate(:page => params[:page])
      end
    else
      errPerms()
    end
  end
  
  # GET /compros
  # GET /compros.xml
  def index
    @pagetitle = "compros"
    
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'compros'
  end

  # GET /compros/1
  # GET /compros/1.xml
  def show
    @compro = Compro.find(params[:id])
    @pagetitle = "compros - #{@compro.code}"
  end

  # GET /compros/new
  # GET /compros/new.xml
  def new
    @pagetitle = "New compro"
    
    if(params[:company_id])
      @company = Company.find(params[:company_id])
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @transports = @company.get_transports()
    @ac_user = getUsername()
    
      if(@company.can_view(current_user))
        @compro = Compro.new
        @compro.company_id = @company.id
      else
        errPerms()
      end
    else
      redirect_to('/companies')
    end
  end

  # GET /compros/1/edit
  def edit
    @pagetitle = "Edit compro"
    
    @compro = Compro.find(params[:id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @transports = @company.get_transports()
    
    
  end

  # POST /compros
  # POST /compros.xml
  def create
    @pagetitle = "New compro"
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @transports = @company.get_transports()
    @ac_user = getUsername()
    
    @company = Company.find(params[:compro][:company_id])
    @compro = Compro.new(compro_params)

    respond_to do |format|
      if @compro.save
        format.html { redirect_to(@compro, :notice => 'compro was successfully created.') }
        format.xml  { render :xml => @compro, :status => :created, :location => @compro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @compro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /compros/1
  # PUT /compros/1.xml
  def update
    @pagetitle = "Edit compro"
    
    @compro = Compro.find(params[:id])

    respond_to do |format|
      if @compro.update_attributes(compro_params)
        format.html { redirect_to(@compro, :notice => 'compro was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @compro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /compros/1
  # DELETE /compros/1.xml
  def destroy
    @compro = Compro.find(params[:id])
    
    # Erase compro id for products from compro
    #products = Product.find( {:compro_id => @compro[:id]})
    
   # for product in products
   #   product.compro_id = nil
   #   product.save
   # end
    
    @company = @compro.company
    @compro.destroy

    respond_to do |format|
      format.html { redirect_to "/companies/compros/#{@company.id}" }
      format.xml  { head :ok }
    end
  end
  
  
    # Create via ajax
  def create_ajax
    if(params[:company_id] and params[:company_id] != "" and params[:code] and params[:numero] != "")
      @compro = Compro.new(:company_id => params[:company_id].to_i, :code => params[:code], :comments => params[:comments])
      
      if @customer.save
        render :text => "#{@compro.id}|BRK|#{@compro.code}"
      else
        render :text => "error"
      end
    else
      render :text => "error_empty"
    end
  end

  def compro_params
    params.require(:compro).permit(:tranportorder_id, :fecha,:descrip,:document_id, :code,:importe, :detalle,:company_id,:location_id,:division_id)
  end
  
  

end

