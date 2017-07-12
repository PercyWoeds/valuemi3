
include UsersHelper
include ProductsHelper

class AjustsController < ApplicationController
  before_filter :authenticate_user!, :checkProducts
##
## REPORTE DE COMPRAS 
##    
 
 def build_pdf_header1(pdf)
    pdf.font "Helvetica" , :size => 6    
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

  def build_pdf_body1(pdf)
    
    pdf.text "Ordenes de compra Emitidas : Fecha "+@fecha1.to_s+ " Mes : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  

      headers = []
      table_content = []

      ajust::TABLE_HEADERS1.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

      for ordencompra in @rpt_detalle_ajust

           $lcNumero = ordencompra.code    
           $lcFecha = ordencompra.fecha1
           $lcProveedor = ordencompra.supplier.name 

          @orden_compra1  = @company.get_orden_detalle(ordencompra.id)


       for  orden in @orden_compra1
            row = []
            row << nroitem.to_s
            row << $lcProveedor 
            row << $lcNumero 
            row << $lcFecha.strftime("%d/%m/%Y")        
            row << orden.quantity.to_s
            row << orden.product.code
            row << orden.product.name
            row << orden.price.round(2).to_s
            row << orden.discount.round(2).to_s
            row << orden.total.round(2).to_s
            table_content << row
            puts nroitem.to_s 
            nroitem=nroitem + 1
        end

      end


      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:center
                                          columns([3]).align=:center
                                          columns([4]).align=:left
                                          columns([5]).align=:left
                                          columns([6]).align=:left
                                          columns([7]).align=:right
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                        end

      pdf.move_down 10      
      pdf

    end


    def build_pdf_footer1(pdf)

        pdf.text ""
        pdf.text "" 
        

     end
    

  # Export ajust to PDF
  def rpt_ajust_all
        
    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]

    @rpt_detalle_ajust = @company.get_ajust_detail(@fecha1,@fecha2)

    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header1(pdf)
        pdf = build_pdf_body1(pdf)
        build_pdf_footer1(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

##
##



def build_pdf_header(pdf)

     
     $lcFecha1= @ajust.fecha1.strftime("%d/%m/%Y") 
     
     $lcSubtotal=sprintf("%.2f",(@ajust.subtotal).round(2))
     $lcIgv=sprintf("%.2f",(@ajust.tax).round(2))
     $lcTotal=sprintf("%.2f",(@ajust.total).round(2))

   
     $lcAprobado= @ajust.get_processed 
    
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
          pdf.text "AJUSTES INVENTARIO", :align => :center
          pdf.text "#{@ajust.id}", :align => :center,
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

   
      headers = []
      table_content = []

      Ajust::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1

       for  product in @ajust.get_products()
            row = []
            row << nroitem.to_s      
            row << product.quantity.to_s
            row << product.code
            row << product.name
            row << "0.00"
            row << "0.00"
            row << "0.00"
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
      
      pdf

    end


    def build_pdf_footer(pdf)

        pdf.text ""
        pdf.text "" 
        pdf.text "Descripcion : #{@ajust.description}", :size => 8, :spacing => 4
        pdf.text "Comentarios : #{@ajust.comments}", :size => 8, :spacing => 4
                

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
        pdf.draw_text "Company: #{@ajust.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end
      pdf
      
  end


  # Export ajust to PDF
  def pdf
    @ajust = Ajust.find(params[:id])
    company =@ajust.company_id
    @company =Company.find(company)

    @instrucciones = @company.get_instruccions()


    Prawn::Document.generate("app/pdf_output/#{@ajust.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@ajust.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

 def client_data_headers

    #{@ajust.description}
      client_headers  = [["Proveedor: ", $lcCli ]] 
      client_headers << ["Direccion : ", $lcdir1]
      client_headers << ["Distrito  : ",$lcdis]
      client_headers << ["Provincia : ",$lcProv]     
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
      
      invoice_summary
    end

           
  def populate_order

    for cart_item in @cart.cart_items
    order_item = Item.new(  
    :product_id => cart_item.id,
    :description => cart_item.name,
    :quantity => cart_item.quantity,
    :qty      => cart_item.qty,
    :recibir  => cart_item.recibir
    )

    @ajust.ajust_details << order_item
    end
  end


  def do_grabar_ins
    @ajust = ajust.find(params[:id])    

    populate_order
    
    flash[:notice] = "The ajust order has been grabada."
    redirect_to @ajust
  end
  # Process an ajust
  def do_cerrar
    @ajust = ajust.find(params[:id])
    @ajust[:processed] = "3"
    
    @ajust.process
    
    flash[:notice] = "The ajust order has been processed closed"
    redirect_to @ajust
  end

  def do_process
    @ajust = Ajust.find(params[:id])
    @ajust[:processed] = "1"
    
    @ajust.process
    
    flash[:notice] = "The ajust order has been processed."
    redirect_to @ajust
  end
  
  # Do send ajust via email
  def do_email
    @ajust = ajust.find(params[:id])
    @email = params[:email]
    
    Notifier.ajust(@email, @ajust).deliver
    
    flash[:notice] = "The ajust has been sent successfully."
    redirect_to "/ajusts/#{@ajust.id}"
  end
  
  # Send ajust via email
  def email
    @ajust = ajust.find(params[:id])
    @company = @ajust.company
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
        
        
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_f
        
        total =  product[:quantity]
        
        product[:CurrTotal] = total
        
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
    @suppliers = Supplier.where(["company_id = ? AND (ruc  LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show ajusts for a company
  def list_ajusts
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
          @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any ajusts for that supplier."
          redirect_to "/companies/ajusts/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = supplier.find(params[:supplier])
        
        if @supplier
          @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any ajusts for that supplier."
          redirect_to "/companies/ajusts/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @ajusts = Ajust.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @ajusts = Ajust.where(company_id:  @company.id).order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  # Show ajusts for a company
  def list_receiveorders
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
        @supplier = Supplier.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_supplier].strip})
        
        if @supplier
          @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any ajusts for that supplier."
          redirect_to "/companies/ajusts/#{@company.id}"
        end
      elsif(params[:supplier] and params[:supplier] != "")
        @supplier = Supplier.find(params[:supplier])
        
        if @supplier
          @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :supplier_id => @supplier.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any ajusts for that supplier."
          redirect_to "/companies/ajusts/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @ajusts = Ajust.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @ajusts = Ajust.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @ajusts = Ajust.where(company_id:  @company.id, :processed => "1").order("id DESC").paginate(:page => params[:page])
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /ajusts
  # GET /ajusts.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'ajusts'
    @pagetitle = "ajusts"
  end

  # GET /ajusts/1
  # GET /ajusts/1.xml
  def show
    @ajust = Ajust.find(params[:id])
  @cierre = Cierre.last 

  end

  def new
    @pagetitle = "Nueva Orden Compra"
    @action_txt = "Create"
    
    @cierre = Cierre.last 
    parts0 = @cierre.fecha.strftime("%Y-%m-%d") 
    parts = parts0.split("-")
    
    $yy = parts[0].to_i
    $mm = parts[1].to_i
    $dd = parts[2].to_i 
    
    @ajust = Ajust.new
    
    @ajust[:code] = "#{generate_guid5()}"
    @ajust[:processed] = false
    
    @company = Company.find(params[:company_id])
    @ajust.company_id = @company.id
        
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments  = @company.get_payments()
    @monedas    = @company.get_monedas()
   
        
    @ac_user = getUsername()
    @ajust[:user_id] = getUserId()

  end

  # GET /ajusts/1/edit
  def edit
    @pagetitle = "Editar Orden Compra"
    @action_txt = "Update"
    
    @ajust = Ajust.find(params[:id])
    @company = @ajust.company
    @ac_supplier = @ajust.supplier.name
    @ac_user = @ajust.user.username
    @suppliers = @company.get_suppliers()
    @payments  = @company.get_payments()    
    @monedas  = @company.get_monedas()
    
    @products_lines = @ajust.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /ajusts
  # POST /ajusts.xml
  def create
    @pagetitle = "Nueve Orden de Compra"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @ajust = Ajust.new(ajust_params)
    
    @company = Company.find(params[:ajust][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    @monedas  = @company.get_monedas()

    @tipodocumento = @ajust[:document_id]
    @cierre = Cierre.last 

    
    @ajust[:subtotal] = @ajust.get_subtotal(items)

    @ajust[:tax] = 0
    
    @ajust[:total] = @ajust[:subtotal] 
    
    if(params[:ajust][:user_id] and params[:ajust][:user_id] != "")
      curr_seller = User.find(params[:ajust][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @ajust.save
        # Create products for kit
        @ajust.add_products(items)        
        # Check if we gotta process the ajust
    
        
        @ajust.process()
        
        format.html { redirect_to(@ajust, :notice => 'ajust was successfully created.') }
        format.xml  { render :xml => @ajust, :status => :created, :location => @ajust }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ajust.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /ajusts/1
  # PUT /ajusts/1.xml
  def update
    @pagetitle = "Editar Orden Compra"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @ajust = Ajust.find(params[:id])
    @company = @ajust.company
    
    if(params[:ac_supplier] and params[:ac_supplier] != "")
      @ac_supplier = params[:ac_supplier]
    else
      @ac_supplier = @ajust.supplier.name
    end
    
    @products_lines = @ajust.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @suppliers = @company.get_suppliers()
    @payments = @company.get_payments()    
    
    @monedas  = @company.get_monedas()
    
    @ajust[:subtotal] = @ajust.get_subtotal(items)
    @ajust[:tax]      = @ajust.get_tax(items, @ajust[:supplier_id])
    @ajust[:total]    = @ajust[:subtotal] + @ajust[:tax]

    respond_to do |format|
      if @ajust.update_attributes(params[:ajust])
        # Create products for kit
        @ajust.delete_products()
        @ajust.add_products(items)
        # Check if we gotta process the ajust
        @ajust.process()
        
        format.html { redirect_to(@ajust, :notice => 'ajust was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ajust.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ajusts/1
  # DELETE /ajusts/1.xml
  def destroy
    @ajust = Ajust.find(params[:id])
    company_id = @ajust[:company_id]
    @ajust.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/ajusts/" + company_id.to_s) }
    end
  end

  #reporte de order de compra  

 def build_pdf_header2(pdf)
    pdf.font "Helvetica" , :size => 6    
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



  def build_pdf_body2(pdf)
    
    pdf.text "Ordenes de compra Emitidas : Fecha "+@fecha1.to_s+ " Hasta : "+@fecha2.to_s , :size => 11 
    pdf.text ""
    pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>6
  

      headers = []
      table_content = []

      ajust::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcmonedasoles   = 2
      lcmonedadolares = 1
    

      lcDoc='FT'      

       lcCliente = @rpt_ajust.first.supplier_id

       for  product in @rpt_ajust
        
          if lcCliente == product.supplier_id
            
          
             
            row = []          
            row << nroitem.to_s 
            row << product.code
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            row << product.supplier.name
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                row << "0.00 "
                row << sprintf("%.2f",product.total.to_s)
            else
                row << sprintf("%.2f",product.total.to_s)
                row << "0.00 "
            end 
            row << " "
            
            table_content << row

            nroitem = nroitem + 1

          else
            totals = []            
            total_cliente_soles = 0
            total_cliente_soles = @company.get_purchases_by_day_value_supplier(@fecha1,@fecha2,lcmonedadolares,lcCliente)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_purchases_by_day_value_supplier(@fecha1,@fecha2,lcmonedasoles,lcCliente)
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""          
            row << "TOTALES POR PROVEEDOR=> "            
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)
            row << " "
            
            table_content << row

            lcCliente = product.supplier_id

            row = []          
            row << lcDoc
            row << product.code
            row << product.fecha1.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            row << product.supplier.name
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                row << "0.00 "
                row << sprintf("%.2f",product.total.to_s)
            else
                row << sprintf("%.2f",product.total.to_s)
                row << "0.00 "
            end 
            row << " "

            
            table_content << row



          end 
          
         
        end

            lcProveedor = @rpt_ajust.last.supplier_id 

            totals = []            
            total_cliente = 0

            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_ajusts_day_value2(@fecha1,@fecha2, lcProveedor, lcmonedadolares,'total')
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_ajusts_day_value2(@fecha1,@fecha2, lcProveedor, lcmonedasoles,'total')
    
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""          
            row << "TOTALES POR PROVEEDOR => "            
            row << ""
            row << sprintf("%.2f",total_cliente_dolares.to_s)
            row << sprintf("%.2f",total_cliente_soles.to_s)                      
            row << " "
            table_content << row
              
          total_soles   = @company.get_ajusts_totalday_value(@fecha1,@fecha2, "total",lcmonedasoles)
          total_dolares = @company.get_ajusts_totalday_value(@fecha1,@fecha2, "total",lcmonedadolares)
      
           if $lcxCliente == "0" 

          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << "TOTALES => "
          row << ""
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
          table_content << row
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
                                          columns([8]).align=:right
                                        end                                          
                                        
      pdf.move_down 10      

      #totales 

      pdf 

    end


    def build_pdf_footer2(pdf)

        pdf.text ""
        pdf.text "" 
        

     end
    

  # Export ajust to PDF
  def rpt_ajust2_all
    $lcxCliente = "0" 
    @company =Company.find(1)
    @fecha1 =params[:fecha1]
    @fecha2 =params[:fecha2]

    @rpt_ajust = @company.get_ajust_detail2(@fecha1,@fecha2)

    Prawn::Document.generate("app/pdf_output/orden_1.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header2(pdf)
        pdf = build_pdf_body2(pdf)
        build_pdf_footer2(pdf)
        $lcFileName =  "app/pdf_output/orden_1.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  

  end

##
##

  #fin reporte de orden de compra 
 
  private
  def ajust_params
    params.require(:ajust).permit(:company_id,:location_id,:division_id,:supplier_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:moneda_id,:fecha1,:fecha2,:payment_id)

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

end 


