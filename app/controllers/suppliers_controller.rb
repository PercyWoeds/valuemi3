include UsersHelper
include CompaniesHelper


class SuppliersController < ApplicationController
  before_filter :authenticate_user!, :checkCompanies

  def import
      Supplier.import(params[:file])
       redirect_to root_url, notice: "Proveedor  importadas."
  end 
  

  # Show suppliers for a company
  def list_suppliers
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Suppliers"
  
    if(@company.can_view(current_user))
     if(params[:search] and params[:search] != "")                     
        
        @suppliers = Supplier.where(["company_id = ? and (ruc LIKE ? OR name LIKE ?)", @company.id,"%" + params[:search] + "%", "%" + params[:search] + "%"]).order('name').paginate(:page => params[:page]) 
      else
        @suppliers = Supplier.where(company_id: @company.id).paginate(:page => params[:page])
      end
    else
      errPerms()
    end
  end
  
  # GET /suppliers
  # GET /suppliers.xml
  def index
    @pagetitle = "Suppliers"
    
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'suppliers'
  end

  # GET /suppliers/1
  # GET /suppliers/1.xml
  def show
    @supplier = Supplier.find(params[:id])
    @pagetitle = "Suppliers - #{@supplier.name}"
  end

  # GET /suppliers/new
  # GET /suppliers/new.xml
  def new
    @pagetitle = "New supplier"
    
    if(params[:company_id])
      @company = Company.find(params[:company_id])
    
      if(@company.can_view(current_user))
        @supplier = Supplier.new
        @supplier.company_id = @company.id
      else
        errPerms()
      end
    else
      redirect_to('/companies')
    end
  end

  # GET /suppliers/1/edit
  def edit
    @pagetitle = "Edit supplier"
    
    @supplier = Supplier.find(params[:id])
  end

  # POST /suppliers
  # POST /suppliers.xml
  def create
    @pagetitle = "New supplier"
    
    @company = Company.find(params[:supplier][:company_id])
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully created.') }
        format.xml  { render :xml => @supplier, :status => :created, :location => @supplier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /suppliers/1
  # PUT /suppliers/1.xml
  def update
    @pagetitle = "Edit supplier"
    
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      if @supplier.update_attributes(supplier_params)
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.xml
  def destroy
    @supplier = Supplier.find(params[:id])
    
    # Erase supplier id for products from supplier
    #products = Product.find( {:supplier_id => @supplier[:id]})
    
   # for product in products
   #   product.supplier_id = nil
   #   product.save
   # end
    
    @company = @supplier.company
    @supplier.destroy

    respond_to do |format|
      format.html { redirect_to "/companies/suppliers/#{@company.id}" }
      format.xml  { head :ok }
    end
  end
  
  
    # Create via ajax
  def create_ajax
    if(params[:company_id] and params[:company_id] != "" and params[:name] and params[:name] != "")
      @supplier = Supplier.new(:company_id => params[:company_id].to_i, :name => params[:name], :email => params[:email], :phone1 => params[:phone1], :phone2 => params[:phone2], :address1 => params[:address1], :address2 => params[:address2], :city => params[:city], :state => params[:state], :zip => params[:zip], :country => params[:country], :comments => params[:comments],:ruc=>params[:ruc])
      
      if @customer.save
        render :text => "#{@supplier.id}|BRK|#{@supplier.name}"
      else
        render :text => "error"
      end
    else
      render :text => "error_empty"
    end
  end

  def supplier_params
    params.require(:supplier).permit(:name, :email, :phone1, :phone2, :address1,:address2,:city, :state,:zip,:country,:comments,:ruc,:company_id,:taxable )    
  end
  

end
