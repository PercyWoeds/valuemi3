include UsersHelper
include CompaniesHelper

class CustomersController < ApplicationController
  before_filter :authenticate_user!, :checkCompanies
  
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # Show customers for a company

  def import
      Customer.import(params[:file])
       redirect_to root_url, notice: "Clientes importadas."
  end 
  def import2
      Customer.import2(params[:file])
       redirect_to root_url, notice: "Clientes direcciones importadas."
  end 
    

  def list_customers
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Clientes"
  
    if(@company.can_view(current_user))
      if(params[:search] and params[:search] != "")                 
  
        @customers = Customer.where(["company_id = ? AND  (ruc LIKE ? OR name LIKE ?)", @company.id,"%" + params[:search] + "%", "%" + params[:search] + "%"]).order('name').paginate(:page => params[:page]) 
      else
        @customers = Customer.where(:company_id => @company.id).order("name").paginate(:page => params[:page])
      end
    else
      errPerms()
    end
  end
  
  # GET /customers
  # GET /customers.xml
  def index
    @companies = Company.where(user_id: getUserId()).order("name")
    @path = 'customers'
    @pagetitle = "Customers"
    
    @products = Customer.all 
    respond_to do |format|
      format.html
      format.csv { send_data @products.to_csv }
    
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.xml
  def new
    @pagetitle = "New customer"
    
    @customer = Customer.new
    @customer[:taxable] = true
    @customer[:account] = "C_#{generate_guid()}"
    
    @company = Company.find(params[:company_id])
    @customer.company_id = @company.id
    
    if(params[:ajax])
      @ajax = true
      render :layout => false
    end
  end

  # GET /customers/1/edit
  def edit
    @pagetitle = "Edit customer"
    
    @customer = Customer.find(params[:id])
    @edit = true
    
    @company = Company.find(@customer[:company_id])
  end
  
  # Create via ajax
  def create_ajax
    if(params[:company_id] and params[:company_id] != "" and params[:name] and params[:name] != "")
      @customer = Customer.new(:company_id => params[:company_id].to_i, :name => params[:name], :email => params[:email], :phone1 => params[:phone1], :phone2 => params[:phone2], :address1 => params[:address1], :address2 => params[:address2], :city => params[:city], :state => params[:state], :zip => params[:zip], :country => params[:country], :comments => params[:comments], :account => params[:account], :taxable => params[:taxable])
      
      if @customer.save
        render :text => "#{@customer.id}|BRK|#{@customer.name}"
      else
        render :text => "error"
      end
    else
      render :text => "error_empty"
    end
  end

  # POST /customers
  # POST /customers.xml
  def create
    @pagetitle = "New customer"
    
    @customer = Customer.new(customer_params)
    
    @company = Company.find(params[:customer][:company_id])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(@customer, :notice => 'Customer was successfully created.') }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @pagetitle = "Edit customer"
    
    @customer = Customer.find(params[:id])
    @edit = true
    
    @company = Company.find(@customer[:company_id])

    respond_to do |format|
      if @customer.update_attributes(customer_params)
        format.html { redirect_to(@customer, :notice => 'Customer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Customer.find(params[:id])
    company_id = @customer[:company_id]
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/customers/" + company_id.to_s) }
      format.xml  { head :ok }
    end
  end
  
    private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:company_id,:email,:phone1,:phone2,:address1,:address2,:city,:state,:zip,:country,:comments,:account,:taxable,:name,:ruc)
    end

end
