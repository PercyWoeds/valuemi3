
include UsersHelper
include CustomersHelper
include ProductsHelper

class OutputsController < ApplicationController
  before_filter :authenticate_user!, :checkProducts

  
  # reporte completo
  def build_pdf_header_rpt(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers_rpt.length >= row ? client_data_headers_rpt[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_rpt.length >= row ? invoice_headers_rpt[rows_index] : ['',''])
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
      pdf 
  end   

  def build_pdf_body_rpt(pdf)
    
    pdf.text "Listado de Salidas desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
  
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Output::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcDoc='FT'
      lcMon='S/.'
      @total = 0
      @totales = 0
      @cantidad = 0
      nroitem = 1

       for  product in @facturas_rpt
 
            row = []         
            row << nroitem.to_s
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            row << product.supplier.name  
            row << product.employee.full_name
            row << product.truck.placa            
            row << sprintf("%.2f",product.quantity.to_s)
            row << sprintf("%.2f",product.price.to_s)
            @total = product.quantity * product.price
            row << sprintf("%.2f",@total.to_s)
          
            table_content << row

            @totales += @total  
            @cantidad += product.quantity

            nroitem=nroitem + 1
       
        end
      
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      
      row << "TOTALES => "
      row << sprintf("%.2f",@cantidad.to_s)
      row << " "
      row << sprintf("%.2f",@totales.to_s)


      table_content << row
      
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([5]).align=:center  
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt(pdf)
            data =[ ["Procesado por Almacen ","V.B.Almacen","V.B.Compras ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          

                        
      pdf.text "" 
      pdf.bounding_box([0, 30], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end


# Export serviceorder to PDF
  def rpt_salidas_all_pdf

    $lcFacturasall = '1'

    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @product = params[:ac_item_id]    

    @products = @company.get_products_dato(@product)        

    @facturas_rpt = @company.get_salidas_day(@fecha1,@fecha2,@product)


    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end

####

#reporte x familia
####


  # reporte completo
  def build_pdf_header_rpt2(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers_rpt.length >= row ? client_data_headers_rpt[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_rpt.length >= row ? invoice_headers_rpt[rows_index] : ['',''])
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
      pdf 
  end   

  def build_pdf_body_rpt2(pdf)
    
    pdf.text "Listado de Salidas desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
  
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Output::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcDoc='FT'
      lcMon='S/.'

      @totales = 0
      @cantidad = 0
      nroitem = 1

       for  product in @facturas_rpt
 
            row = []         
            row << nroitem.to_s
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.codigo
            row << product.nameproducto
            row << product.unidad 
            
            row << product.employee.full_name
            row << product.truck.placa            
            row << sprintf("%.2f",product.quantity.to_s)
            row << sprintf("%.2f",product.price.to_s)

            calculartotal =product.price*product.quantity

            row << sprintf("%.2f",calculartotal.to_s)
          
            table_content << row

            @totales += calculartotal 
            @cantidad += product.quantity

            nroitem=nroitem + 1
       
        end
      
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      
      row << ""
      row << ""
      
      row << "TOTALES => "
      row << sprintf("%.2f",@cantidad.to_s)
      row << " "
      row << sprintf("%.2f",@totales.to_s)


      table_content << row
      
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([5]).align=:center  
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt2(pdf)
            data =[ ["Procesado por Almacen ","V.B.Compras ","V.B. Gerente ."],
               [":",":",":"],
               [":",":",":"],
               ["Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          

                        
      pdf.text "" 
      pdf.bounding_box([0, 30], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end



# Export serviceorder to PDF
  def rpt_salidas2_all_pdf

    @company=Company.find(params[:id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @categoria = params[:products_category_id]    

    @facturas_rpt = @company.get_salidas_day2(@fecha1,@fecha2,@categoria)

    puts @categoria

    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end



 
def build_pdf_header(pdf)

     $lcCli  =  @purchaseorder.supplier.name
     $lcdir1 = @purchaseorder.supplier.address1
     $lcdir2 =@purchaseorder.supplier.address2
     $lcdis  =@purchaseorder.supplier.city
     $lcProv = @purchaseorder.supplier.state
     $lcFecha1= @purchaseorder.fecha1.strftime("%d/%m/%Y") 
     $lcMon=@purchaseorder.moneda.description     
     $lcPay= @purchaseorder.payment.descrip

     $lcSubtotal=sprintf("%.2f",(@purchaseorder.subtotal).round(2))
     $lcIgv=sprintf("%.2f",(@purchaseorder.tax).round(2))
     $lcTotal=sprintf("%.2f",(@purchaseorder.total).round(2))

     $lcDetracion=@purchaseorder.detraccion
     $lcAprobado= @purchaseorder.get_processed 
    
      pdf.image "#{Dir.pwd}/public/images/logo2.png", :width => 270
        
      pdf.move_down 6
        
      pdf.move_down 4
      #pdf.text supplier.street, :size => 10
      #pdf.text supplier.district, :size => 10
      #pdf.text supplier.city, :size => 10
      pdf.move_down 4

      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C: 20424092941", :align => :center
          pdf.text "ORDEN DE COMPRA", :align => :center
          pdf.text "#{@purchaseorder.code}", :align => :center,
                                 :style => :bold          
        end
      end
      pdf.move_down 25
      pdf 
  end   

  def build_pdf_body(pdf)
    
    pdf.text "__________________________________________________________________________", :size => 13, :spacing => 4
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 8

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

        pdf.move_down 20

      end

      headers = []
      table_content = []

      Purchaseorder::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @purchaseorder.get_products()
            row = []
            row << nroitem.to_s      
            row << product.quantity.to_s
            row << product.code
            row << product.name
            row << product.price.round(2).to_s
            row << product.discount.round(2).to_s
            row << product.total.round(2).to_s
            table_content << row

            nroitem=nroitem + 1
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:right
                                          columns([2]).align=:center
                                          columns([3]).align=:center
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                          columns([6]).align=:right
                                         
                                        end

      pdf.move_down 10      
      pdf.table invoice_summary, {
        :position => :right,
        :cell_style => {:border_width => 1},
        :width => pdf.bounds.width/2
      } do
        columns([0]).font_style = :bold
        columns([1]).align = :right
        
      end
      pdf

    end


    def build_pdf_footer(pdf)

        pdf.text ""
        pdf.text "" 
        pdf.text "Descripcion : #{@purchaseorder.description}", :size => 8, :spacing => 4
        pdf.text "Comentarios : #{@purchaseorder.comments}", :size => 8, :spacing => 4
        
      
        data =[[{:content=> $lcEntrega4,:colspan=>2},"" ] ,
               [$lcEntrega1,{:content=> $lcEntrega3,:rowspan=>2}],
               [$lcEntrega2]               
               ]

           {:border_width=>0  }.each do |property,value|
            pdf.text " Instrucciones: "
            pdf.table(data,:cell_style=> {property =>value})
            pdf.move_down 20          
           end     

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        
        pdf.text "_________________               _____________________         ____________________      ", :size => 13, :spacing => 4
        pdf.text ""
        pdf.text "                  Realizado por                                                 V.B.Jefe Compras                                            V.B.Gerencia           ", :size => 10, :spacing => 4
        pdf.draw_text "Company: #{@purchaseorder.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end


  # Export purchaseorder to PDF
  def pdf
    @purchaseorder = Purchaseorder.find(params[:id])
    company =@purchaseorder.company_id
    @company =Company.find(company)

    @instrucciones = @company.get_instruccions()

    @lcEntrega =  @instrucciones.find(1)
    $lcEntrega1 =  @lcEntrega.description1
    
    Prawn::Document.generate("app/pdf_output/#{@purchaseorder.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@purchaseorder.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName            
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
  end

  # Process an output
  def do_process
    @output = Output.find(params[:id])
    @output[:processed] = "1"
    @output[:return] = "0"
    @output.process
    
    flash[:notice] = "The output order has been processed."
    redirect_to @output
  end
  
  # Do send output via email
  def do_email
    @output = Output.find(params[:id])
    @email = params[:email]
    
    Notifier.output(@email, @output).deliver
    
    flash[:notice] = "The output has been sent successfully."
    redirect_to "/outputs/#{@output.id}"
  end

  
  # Send output via email
  def email
    @output = Output.find(params[:id])
    @company = @output.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]        
        
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_f
        product[:price] = price.to_f
                
        total = product[:price] * product[:quantity]
        
        
        product[:CurrTotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  
  # Autocomplete for products
  def ac_products
  @products = Product.find_by_sql(['Select products.code,products.name, products.id,
    stocks.unitary_cost as cost,
    products.tax1, products.tax2,products.tax3,stocks.quantity 
    from products   
    INNER JOIN stocks ON   products.id = stocks.product_id
    WHERE stocks.quantity > 0 and products.company_id = ? 
    AND products.code LIKE ? OR products.name iLIKE ? ',
    params[:company_id], "%" + params[:q] + "%", "%" +  params[:q] + "%"]) 

    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.where(company_id: params[:company_id])
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.where(["id IN (#{user_ids.join(",")}) AND (email LIKE ? OR username LIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
    alr_ids = []
    
    for user in @users
      alr_ids.push(user.id)
    end    
    if(not alr_ids.include?(getUserId()))
      @users.push(current_user)
    end   
    render :layout => false
  end
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show outputs for a company
  def list_outputs
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - outputs"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    
    if(params[:location] and params[:location] != "")
      @sel_location = params[:location]
    end
    
    if(params[:division] and params[:division] != "")
      @sel_division = params[:division]
    end
  
    if(@company.can_view(current_user))
      
       @outputs = Output.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @outputs = Output.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @outputs = Output.all.order('id DESC').paginate(:page => params[:page]) 
        end
    else
      errPerms()
    end
  end
  
  # GET /outputs
  # GET /outputs.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'outputs'
    @pagetitle = "outputs"
  end

  # GET /outputs/1
  # GET /outputs/1.xml
  def show
    @output = Output.find(params[:id])
    @supplier = @output.supplier
    @employee = @output.employee
    @truck  = @output.truck
    @cierre = Cierre.last 
    parts0 = @cierre.fecha.strftime("%Y-%m-%d") 
    parts =parts0.split("-")
    
    $yy = parts[0].to_i
    $mm = parts[1].to_i
    $dd = parts[2].to_i 
  end

  # GET /outputs/new
  # GET /outputs/new.xml

  

  def new
    @pagetitle = "New output"
    @action_txt = "Create"
    
    @output = Output.new
    @output[:code] = "#{generate_guid10()}"
    @output[:processed] = false
    
    @company = Company.find(params[:company_id])
    @output.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @suppliers = @company.get_suppliers()
    @employees = @company.get_employees()
    @trucks = @company.get_trucks()    
   
    @cierre = Cierre.last 
    parts0 = @cierre.fecha.strftime("%Y-%m-%d") 
    parts =parts0.split("-")
    
    $yy = parts[0].to_i
    $mm = parts[1].to_i
    $dd = parts[2].to_i 
    
    puts $yy
    puts $mm
    puts $dd
    
    @ac_user = getUsername()
    @output[:user_id] = getUserId()
  end


  # GET /outputs/1/edit
  def edit
    @pagetitle = "Edit output"
    @action_txt = "Update"
    
    @output = Output.find(params[:id])
    @company = @output.company
    @ac_customer = @output.customer.name
    @ac_user = @output.user.username
    
    @suppliers = @company.get_suppliers()
    @employees = @company.get_employees()
    @trucks = @company.get_trucks()    
    
    @products_lines = @output.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /outputs
  # POST /outputs.xml
  def create
    @pagetitle = "New output"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @output = Output.new(output_params)
    
    @company = Company.find(params[:output][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()

    @suppliers = @company.get_suppliers()
    @employees = @company.get_employees()
    @trucks = @company.get_trucks()    
    

    
    @output[:subtotal] = @output.get_subtotal(items)
    
    begin
      @output[:tax] = @output.get_tax(items)
    rescue
      @output[:tax] = 0
    end
    
    @output[:total] = @output[:subtotal] + @output[:tax]
    
    if(params[:output][:user_id] and params[:output][:user_id] != "")
      curr_seller = User.find(params[:output][:user_id])
      @ac_user = curr_seller.username
    end
    
    
    respond_to do |format|
      if @output.save 
        # Create products for kit
        @output.add_products(items)
        
        # Check if we gotta process the output
        @output.process()
        @output.correlativo

        
        format.html { redirect_to(@output, :notice => 'output was successfully created.') }
        format.xml  { render :xml => @output, :status => :created, :location => @output }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @output.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /outputs/1
  # PUT /outputs/1.xml
  def update
    @pagetitle = "Edit output"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @output = Output.find(params[:id])
    @company = @output.company
    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @output.customer.name
    end
    
    @products_lines = @output.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @output[:subtotal] = @output.get_subtotal(items)
    @output[:tax] = @output.get_tax(items)
    @output[:total] = @output[:subtotal] + @output[:tax]



    respond_to do |format|
      if @output.update_attributes(params[:output])
        # Create products for kit
        @output.delete_products()
        @output.add_products(items)
        
        # Check if we gotta process the output
        @output.process()

        
        format.html { redirect_to(@output, :notice => 'output was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @output.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /outputs/1
  # DELETE /outputs/1.xml
  def destroy
    @output = Output.find(params[:id])
    company_id = @output[:company_id]

    @outputdetail = OutputDetail.where(:output_id=> @output.id)

    proceso = @output.processed 
    $fecha  = @output.fecha

    if @output.destroy

      if @outputdetail 
        if proceso == "1"

          for ip in @outputdetail

             stock_product =  Stock.find_by(:product_id => ip.product_id)

            if stock_product 
               $last_stock = stock_product.quantity + ip.quantity
               stock_product.unitary_cost = ip.price   
               stock_product.quantity = $last_stock

            else
              $last_stock = 0
              stock_product= Stock.new(:store_id=>1,:state=>"Lima",:unitary_cost=> ip.price ,
              :quantity=> ip.quantity,:minimum=>0,:user_id=>@user_id,:product_id=>ip.product_id,
              :document_id=>1,:documento=>"AJUSTE X ELIMINACION")           
            end 
             stock_product.save      
             @outputdetail.destroy(ip.id)       

          end 

        
        end         
        
      end  
      
    end 



    respond_to do |format|
      format.html { redirect_to("/companies/outputs/" + company_id.to_s) }
    end
  end

  def client_data_headers_rpt
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers_rpt            
      invoice_headers  = [["Fecha : ",$lcHora]]    
      invoice_headers
  end


  private
  def output_params
    params.require(:output).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:employee_id,:truck_id,:fecha )
  end

end




