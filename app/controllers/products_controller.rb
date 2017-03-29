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

    @company = Company.find_by(user_id: current_user.id)
    @products = @company.get_products2
    

  respond_to do |format|
    format.html
    format.xls # { send_data @products.to_csv(col_sep: "\t") }
  end

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

################# REPORTE DE PRODUCTOS #########################

def build_pdf_header(pdf)

    pdf.font "Helvetica"

     $lcCli  = @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers.length, invoice_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers.length >= row ? client_data_headers[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers.length >= row ? invoice_headers[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 10

      end

      pdf.move_down 5
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "Productos : " , :size => 11 

    pdf.font "Open Sans",:size =>6

      headers = []
      table_content = []

      Product::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end



     table_content << headers

      nroitem = 1
      @cantidad = 0
      @totales  = 0
      saldo = 0  

      lcCli = @products.first.products_category.id
      $lcCliName = @products.first.products_category.category

            row = []
            row << nroitem.to_s        
            row << $lcCliName 
            table_content << row      

       for  product in @products

        if  product.products_category != nil  

          if lcCli == product.products_category.id  

              $lcCliName = product.products_category.category 
              row = []
              row << nroitem.to_s
              row << product.code
              row << product.name
              row << product.unidad
              row << product.ubicacion               
              
              table_content << row
              nroitem=nroitem + 1
          else

            row = []
            row << nroitem.to_s        
            row << product.products_category.category  
            table_content << row      

            $lcCliName = product.products_category.category
            lcCli = product.products_category.id  


          end 
        end 
        end
            
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                          columns([6]).align=:right
                                          columns([7]).align=:right   
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer(pdf)

        pdf.text ""
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

  # Export serviceorder to PDF
  def rpt_product_all
    @company=Company.find(params[:company_id])      
    @products = @company.get_products2
      
    Prawn::Document.generate("app/pdf_output/stocks1.pdf") do |pdf|      

        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/stocks1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    #send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
    send_file("app/pdf_output/stocks1.pdf", :type => 'application/pdf', :disposition => 'inline')
  end

  def client_data_headers

    #{@serviceorder.description}
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers            
      invoice_headers  = [["Fecha : ",$lcHora]]    
      invoice_headers
  end


  private
  def products_params
    params.require(:product).permit(:code, :name, :category, :cost,:price,:price2,:tax1_name, :tax1,:tax2_name,:tax2, :tax3_name,:tax3 ,:quantity,:reorder,:description,:comments,:company_id,:marca_id,:modelo_id,:products_category_id,:unidad,:ubicacion)
  end
  


end
