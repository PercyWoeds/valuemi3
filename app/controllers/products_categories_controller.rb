include UsersHelper
include CompaniesHelper

class ProductsCategoriesController < ApplicationController
  before_filter :authenticate_user!, :checkCompanies
  
  def import
     ProductsCategory.import(params[:file])
      redirect_to root_url, notice: "categories importadas."
  end 

  # List product categories for a company
  def list_products_categories
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Product categories"
    
    if(@company.can_view(current_user))
      @products_categories = ProductsCategory.where(company_id: @company.id).paginate(:page => params[:page])
    else
      errPerms()
    end
  end
  
  # GET /products_categories
  # GET /products_categories.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'products_categories'
    @pagetitle = "Product categories"
  end

  # GET /products_categories/1
  # GET /products_categories/1.xml
  def show
    @products_category = ProductsCategory.find(params[:id])
    @pagetitle = "Product categories - #{@products_category.category}"
  end

  # GET /products_categories/new
  # GET /products_categories/new.xml
  def new
    @pagetitle = "New product category"
    @products_category = ProductsCategory.new
    @company = Company.find(params[:company_id])
    @products_category[:company_id] = @company.id
    
  end

  # GET /products_categories/1/edit
  def edit
    @pagetitle = "Edit product category"
    @products_category = ProductsCategory.find(params[:id])
    @company = Company.find(@products_category[:company_id])
    @products_category[:company_id] = @company.id
    
  end

  # POST /products_categories
  # POST /products_categories.xml
  def create
    @pagetitle = "New product category"
    @products_category = ProductsCategory.new(products_category_params)
    
    
    respond_to do |format|
      if @products_category.save
        format.html { redirect_to(@products_category, :notice => 'Products category was successfully created.') }
        format.xml  { render :xml => @products_category, :status => :created, :location => @products_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @products_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products_categories/1
  # PUT /products_categories/1.xml
  def update
    @pagetitle = "Edit product category"
    @products_category = ProductsCategory.find(params[:id])
    
    respond_to do |format|
      if @products_category.update_attributes(products_category_params)
        format.html { redirect_to(@products_category, :notice => 'Products category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @products_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products_categories/1
  # DELETE /products_categories/1.xml
  def destroy
    @products_category = ProductsCategory.find(params[:id])
    company_id = @products_category[:company_id]
    @products_category.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/products_categories/" + company_id.to_s) }
      format.xml  { head :ok }
    end
  end
  def products_category_params
    params.require(:products_category).permit(:company_id,:category,:code)
  
  end
  
end
