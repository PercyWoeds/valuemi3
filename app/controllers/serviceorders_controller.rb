
include UsersHelper
include SuppliersHelper
include ServicebuysHelper

class ServiceordersController < ApplicationController

  before_filter :authenticate_user!, :checkServices
 

  def build_pdf_header(pdf)

     $lcCli  =  @serviceorder.supplier.name
     $lcdir1 = @serviceorder.supplier.address1
     $lcdir2 =@serviceorder.supplier.address2
     $lcdis  =@serviceorder.supplier.city
     $lcProv = @serviceorder.supplier.state
     $lcFecha1= @serviceorder.fecha1.strftime("%d/%m/%Y") 
     $lcMon=@serviceorder.moneda.description     
     $lcPay= @serviceorder.payment.descrip
     $lcSubtotal=sprintf("%.2f",@serviceorder.subtotal)
     $lcIgv=sprintf("%.2f",@serviceorder.tax)
     $lcTotal=sprintf("%.2f",@serviceorder.total)

     $lcDetracion=sprintf("%.2f",@serviceorder.detraccion)
     $lcAprobado= @serviceorder.get_processed 
    
      pdf.image "#{Dir.pwd}/public/images/logo.png", :width => 270
        
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
          pdf.text "ORDEN DE SERVICIO", :align => :center
          pdf.text "#{@serviceorder.code}", :align => :center,
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

      Serviceorder::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @serviceorder.get_services() 
            row = []
            row << nroitem.to_s
            row << product.quantity.to_s
            row << product.name
            row << product.price.to_s
            row << product.discount
            row << product .total.to_s
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
                                          columns([3]).align=:right
                                          columns([4]).align=:right
                                          columns([5]).align=:right
                                         
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
        pdf.text "Descripcion : #{@serviceorder.description}", :size => 8, :spacing => 4
        pdf.text "Comentarios : #{@serviceorder.comments}", :size => 8, :spacing => 4
        
        

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

        pdf.draw_text "Company: #{@serviceorder.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end



  # Export serviceorder to PDF
  def pdf
    @serviceorder = Serviceorder.find(params[:id])
    company =@serviceorder.company_id
    @company =Company.find(company)

    @instrucciones = @company.get_instruccions()

    @lcEntrega =  @instrucciones.find(1)
    $lcEntrega1 =  @lcEntrega.description1
    $lcEntrega2 =  @lcEntrega.description2
    $lcEntrega3 =  @lcEntrega.description3
    $lcEntrega4 =  @lcEntrega.description4

    Prawn::Document.generate("app/pdf_output/#{@serviceorder.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@serviceorder.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end
  
  # Process an serviceorder
  def do_process
    @serviceorder = Serviceorder.find(params[:id])
    @serviceorder[:processed] = "1"
    
    @serviceorder.process
    
    flash[:notice] = "The serviceorder order has been processed."
    redirect_to @serviceorder
  end
  # Process an serviceorder
  def do_anular
    @serviceorder = Serviceorder.find(params[:id])
    @serviceorder[:processed] = "2"
    
    @serviceorder.anular 
    
    flash[:notice] = "The serviceorder order has been anulado."
    redirect_to @serviceorder
  end
  
  # Do send serviceorder via email
  def do_email
    @serviceorder = Serviceorder.find(params[:id])
    @email = params[:email]
    
    Notifier.serviceorder(@email, @serviceorder).deliver
      
    flash[:notice] = "The serviceorder has been sent successfully."
    redirect_to "/serviceorders/#{@serviceorder.id}"
  end

  def do_grabar_ins
    
    @serviceorder = Serviceorder.find(params[:id])

    @company = @serviceorder.company
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    @monedas  = @company.get_monedas()    
    ##Cerrar la order de servicio 
    @serviceorder[:processed]='3'

    documento =  params[:ac_documento]
    documento_id =  params[:ac_documento_id]

    puts "documento*----------------------------------------------**********"
    puts documento
    puts documento_id    

    submision_hash = {"document_id" => params[:ac_document_id],
                       "documento"  => params[:ac_documento] }

    respond_to do |format|    
    if  @serviceorder.update_attributes(submision_hash)            
        @serviceorder.cerrar()
        
        format.html { redirect_to(@serviceorder, :notice => 'Orden de servicio actualizada  ') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # Send serviceorder via email
  def email
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
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
        discount = parts[3]
        
        product = Servicebuy.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_i
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:currtotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  
  # Autocomplete for products
  def ac_products
    @products = Product.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])   
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
  
  # Autocomplete for suppliers
  def ac_suppliers
    @suppliers = Supplier.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])

    render :layout => false
  end
  
  # Show serviceorders for a company
  
  def list_serviceorders
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - serviceorders"
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
      if(params[:ac_supplier] and params[:ac_supplier] != "")
        @supplier = supplier.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_supplier].strip})
        
        if @supplier
          @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = Supplier.find(params[:supplier])
        
        if @supplier
          @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @serviceorders = Serviceorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @serviceorders = Serviceorder.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /serviceorders
  # GET /serviceorders.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'serviceorders'
    @pagetitle = "serviceorders"
  end

  # GET /serviceorders/1
  # GET /serviceorders/1.xml
  def show
    @serviceorder = Serviceorder.find(params[:id])
    @supplier = @serviceorder.supplier
  end

  # GET /serviceorders/new
  # GET /serviceorders/new.xml
  
  def new
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    @serviceorder = Serviceorder.new
    @serviceorder[:code] = "I_#{generate_guid()}"
    @serviceorder[:processed] = false
    
    @company = Company.find(params[:company_id])
    @serviceorder.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()

    @ac_user = getUsername()
    @serviceorder[:user_id] = getUserId()
  end

  # GET /serviceorders/1/edit
  def edit
    @pagetitle = "Edit serviceorder"
    @action_txt = "Update..."
    
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
    @ac_supplier = @serviceorder.supplier.name
    @ac_user = @serviceorder.user.username
    @suppliers = @company.get_suppliers()
    @servicebuys  = @company.get_servicebuys()
    @payments = @company.get_payments()
    @monedas  = @company.get_monedas()
    
    @products_lines = @serviceorder.services_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /serviceorders
  # POST /serviceorders.xml
  def create
    @pagetitle = "Nueva Orden"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @serviceorder = Serviceorder.new(serviceorder_params)
    
    @company = Company.find(params[:serviceorder][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @servicebuys  = @company.get_servicebuys()
    @payments = @company.get_payments()
    @monedas  = @company.get_monedas()

    @serviceorder[:subtotal] = @serviceorder.get_subtotal(items)
    
    begin
      @serviceorder[:tax] = @serviceorder.get_tax(items, @serviceorder[:supplier_id])
    rescue
      @serviceorder[:tax] = 0
    end
    
    @serviceorder[:total] = @serviceorder[:subtotal] + @serviceorder[:tax]

    @serviceorder[:detraccion] = @serviceorder[:total] * 4/100

    
    if(params[:serviceorder][:user_id] and params[:serviceorder][:user_id] != "")
      curr_seller = User.find(params[:serviceorder][:user_id])
      @ac_user = curr_seller.username    
    end


    respond_to do |format|
      if @serviceorder.save
        # Create products for kit
        @serviceorder.add_services(items)
        
        # Check if we gotta process the serviceorder
        @serviceorder.process()
        
        format.html { redirect_to(@serviceorder, :notice => 'serviceorder was successfully created.') }
        format.xml  { render :xml => @serviceorder, :status => :created, :location => @serviceorder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /serviceorders/1
  # PUT /serviceorders/1.xml
  def update
    @pagetitle = "Editar Orden"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @serviceorder = Serviceorder.find(params[:id])
    @company = @serviceorder.company
    
    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @serviceorder.supplier.name
    end
    
    @products_lines = @serviceorder.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()
    @servicebuys  = @company.get_servicebuys()
    @monedas  = @company.get_monedas()
    
    @serviceorder[:subtotal] = @serviceorder.get_subtotal(items)
    @serviceorder[:tax] = @serviceorder.get_tax(items, @serviceorder[:supplier_id])
    @serviceorder[:total] = @serviceorder[:subtotal] + @serviceorder[:tax]

    respond_to do |format|
      if @serviceorder.update_attributes(params[:serviceorder])
        # Create products for kit
        @serviceorder.delete_products()
        @serviceorder.add_products(items)
        
        # Check if we gotta process the serviceorder
        @serviceorder.process()
        
        format.html { redirect_to(@serviceorder, :notice => 'serviceorder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serviceorder.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /serviceorders/1
  # DELETE /serviceorders/1.xml
  def destroy
    @serviceorder = Serviceorder.find(params[:id])
    company_id = @serviceorder[:company_id]
    @serviceorder.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/serviceorders/" + company_id.to_s) }
    end
  end

  def client_data_headers

    #{@serviceorder.description}
      client_headers  = [["Proveedor :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers << ["Dirección :",$lcdir2]
      client_headers << ["Distrito  :",$lcdis]
      client_headers << ["Provincia :",$lcProv]     
      client_headers
  end

  def invoice_headers            
      invoice_headers  = [["Fecha de emisión : ",$lcFecha1]]
      invoice_headers <<  ["Tipo de moneda : ", $lcMon]
      invoice_headers <<  ["Forma de pago : ",$lcPay ]    
      invoice_headers <<  ["Estado  : ",$lcAprobado ]    
      invoice_headers
  end

  def invoice_summary
      invoice_summary = []
      invoice_summary << ["SubTotal",  ActiveSupport::NumberHelper::number_to_delimited($lcSubtotal,delimiter:",",separator:".").to_s]
      invoice_summary << ["IGV",ActiveSupport::NumberHelper::number_to_delimited($lcIgv,delimiter:",",separator:".").to_s]
      invoice_summary << ["Total", ActiveSupport::NumberHelper::number_to_delimited($lcTotal ,delimiter:",",separator:".").to_s]
      invoice_summary << ["Detraccion", ActiveSupport::NumberHelper::number_to_delimited($lcDetracion,delimiter:",",separator:".")]
      invoice_summary
    end

# reporte completo
  def build_pdf_header_rpt(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers.length, invoice_headers.length, 0].max
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
    
    pdf.text "Orden Servicio  Emitidas : Año "+@year.to_s+ " Mes : "+@month.to_s , :size => 11 
    pdf.text ""
    pdf.font "Helvetica" , :size => 8

      headers = []
      table_content = []

      Delivery::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @serviceorder_rpt

            row = []
            row << nroitem.to_s
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.payment.descrip
            row << product.code
            row << product.supplier.name  
            row << product.subtotal.to_s
            row << product.tax.to_s
            row << product.total.to_s
            row << product.get_processed
            table_content << row

            nroitem=nroitem + 1
            puts nroitem 
        end

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left  
                                          columns([5]).align=:right
                                          columns([6]).align=:right
                                          columns([7]).align=:right
                                        end                                          
      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer_rpt(pdf)
      subtotals = []
      taxes = []
      totals = []
      services_subtotal = 0
      services_tax = 0
      services_total = 0


          subtotal = @company.get_services_year_month_value(@year,@month, "subtotal")
          subtotals.push(subtotal)
          services_subtotal += subtotal          
          pdf.text subtotal.to_s
        
        
          tax = @company.get_services_year_month_value(@year,@month, "tax")
          taxes.push(tax)
          services_tax += tax
        
          pdf.text tax.to_s
          
          total = @company.get_services_year_month_value(@year,@month, "total")
          totals.push(total)
          services_total += total
        
          pdf.text total.to_s
        
        
        pdf.text "" 

        pdf.bounding_box([0, 20], :width => 535, :height => 40) do
        pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end



  # Export serviceorder to PDF
  def rpt_serviceorder_all_pdf
    @company=Company.find(params[:id])      
    
    
    if(params[:year] and params[:year].numeric?)
      @year = params[:year].to_i
    else
      @year = Time.now.year
    end
    
    if(params[:month] and params[:month].numeric?)
      @month = params[:month].to_i
    else
      @month = Time.now.month
    end
    

    @serviceorder_rpt = @company.get_services_year_month(@year,@month)  
      
    Prawn::Document.generate("app/pdf_output/rpt_serviceall.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_serviceall.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

  def receive
    @serviceorder = Serviceorder.find(params[:id])
    @supplier = @serviceorder.supplier
    @company = Company.find(@serviceorder.company_id)
    @documents =@company.get_documents()


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
def list_receive_serviceorders
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Orden Compra"
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
      if(params[:ac_supplier] and params[:ac_supplier] != "")
        @supplier = supplier.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_supplier].strip})
        
        if @supplier
          @serviceorders = Seriveorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])
        
        if @supplier
          @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any serviceorders for that supplier."
          redirect_to "/companies/serviceorders/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @serviceorders = Serviceorder.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @serviceorders = Serviceorder.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @serviceorders = Serviceorder.where(company_id:  @company.id, :processed => "1").order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  
  private
  def serviceorder_params
    params.require(:serviceorder).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:detraccion,:payment_id,:moneda_id,:fecha1,:fecha2,:fecha3,:fecha4,:document_id,:documento)
  end

end

