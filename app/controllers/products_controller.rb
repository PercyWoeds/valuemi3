include UsersHelper
include CompaniesHelper

class ProductsController < ApplicationController
  before_filter :authenticate_user!, :checkCompanies



  def import
     Product.import(params[:file])
      redirect_to root_url, notice: "categories importadas."
  end 

  # Autocomplete for products
  def ac_products
    @products = Product.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
    render :layout => false
  end
  
  # Autocomplete for categories
  def ac_categories
    @ac_categoriess = ProductsCategory.where(["company_id = ? AND category LIKE ?", params[:company_id], "%" + params[:q] + "%"])
    render :layout => false
  end 
  
  # List products for a company
  def list_products
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Products"
  
    if(@company.can_view(current_user))
      if(params[:restock])
        @products = Product.where(["company_id = ? AND quantity <= reorder", @company.id]).order('name').paginate(:page => params[:page]) 
        @view_restock = true
      else
        if(params[:search] and params[:search] != "")         
          @products = Product.where(["company_id = ? and (code LIKE ? OR name LIKE ?)", @company.id,"%" + params[:search] + "%", "%" + params[:search] + "%"]).order('code').paginate(:page => params[:page]) 
        else
          @products = Product.where(["company_id = ?",@company.id ]).order('code').paginate(:page => params[:page]) 
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /products
  # GET /products.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'products'
    @pagetitle = "Products"
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    @pagetitle = "Products - #{@product.name}"
    
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @pagetitle = "New product"
    
    @product = Product.new
    @product[:cost] = 0
    @product[:quantity] = 0

    @product[:quantity_transit] = 0
    @product[:company_id] = params[:company_id]
    @product[:price] = 0
    
    @company    = Company.find(params[:company_id])
    @suppliers  = @company.get_suppliers()
    @marcas     = @company.get_marcas()
    @modelos    = @company.get_modelos()
    @categories = @company.get_categories()

    @product[:tax1_name] = @company.get_last_tax_name(1)
    @product[:tax2_name] = @company.get_last_tax_name(2)
    @product[:tax2_name] = @company.get_last_tax_name(3)
    
    if(@company.get_last_tax(1))
      @product[:tax1] = @company.get_last_tax(1)
    else
      @product[:tax1] = 0
    end
    
    if(@company.get_last_tax(2))
      @product[:tax2] = @company.get_last_tax(2)
    else
      @product[:tax2] = 0
    end
    
    if(@company.get_last_tax(3))
      @product[:tax3] = @company.get_last_tax(3)
    else
      @product[:tax3] = 0
    end
    
    if(not @company.can_view(current_user))
      errPerms()
    end
  end

  # GET /products/1/edit
  def edit
    @pagetitle = "Edit product"
    
    @product = Product.find(params[:id])
    @company = @product.company
    @suppliers = @company.get_suppliers()
    @marcas = @company.get_marcas()
    @modelos = @company.get_modelos()
    @categories = @company.get_categories()
  end

  # POST /products
  # POST /products.xml
  def create
    @pagetitle = "New product"
    
    @product = Product.new(products_params)
    @company = Company.find(params[:product][:company_id])
    @suppliers = @company.get_suppliers()
    @marcas = @company.get_marcas()
    @modelos = @company.get_modelos()
    
    if(@product[:tax1] == nil)
      @product[:tax1] = 0
    end
    
    if(@product[:tax2] == nil)
      @product[:tax2] = 0
    end
    
    if(@product[:tax3] == nil)
      @product[:tax3] = 0
    end
    
    if(@company.can_view(current_user))
      respond_to do |format|
      if   @product.save    
          #@product.add_category(@product[:category])          
          format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
          format.xml  { render :xml => @product, :status => :created, :location => @product }
       else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end

      end
    else
      errPerms()
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @pagetitle = "Edit product"
    
    @product = Product.find(params[:id])
    @company = @product.company
    @suppliers = @company.get_suppliers()
    @marcas = @company.get_marcas()
    @modelos = @company.get_modelos()
    @categories = @company.get_categories() 

    respond_to do |format|
      if @product.update_attributes(products_params)
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    
    # Erase from product kits
    kits_products = KitsProduct.where(product_id:  @product[:id])
    
    for product in kits_products
      product.destroy
    end
    
    company_id = @product[:company_id]
    @product.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/products/" + company_id.to_s) }
      format.xml  { head :ok }
    end
  end

  def who_bought
  @product = Product.find(params[:id])
  respond_to do |format|
  format.atom
  end
  end
  private
  def products_params
    params.require(:product).permit(:code, :name, :category, :cost,:price,:price2,:tax1_name, :tax1,:tax2_name,:tax2, :tax3_name,:tax3 ,:quantity,:reorder,:description,:comments,:company_id,:marca_id,:modelo_id,:products_category_id,:unidad,:ubicacion)
  end
  


end
