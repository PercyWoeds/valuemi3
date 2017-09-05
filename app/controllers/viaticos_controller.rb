
include UsersHelper
include CustomersHelper
include ProductsHelper

class ViaticosController < ApplicationController
  before_filter :authenticate_user!, :checkProducts
     
  
 
  def build_pdf_header(pdf)
    
      pdf.image "#{Dir.pwd}/public/images/logo2.png", :width => 270        
      pdf.move_down 6        
      pdf.move_down 4
      #pdf.text customer.street, :size => 10
      #pdf.text customer.district, :size => 10
      #pdf.text customer.city, :size => 10
      pdf.move_down 4

      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C: 20424092941", :align => :center
          pdf.text "LIQUIDACION DE VIATICOS", :align => :center
          pdf.text "#{@viatico.code}", :align => :center,
                                 :style => :bold
          
        end
      end
      pdf.move_down 10
      pdf 
  end   

  def build_pdf_body(pdf)
  
    pdf.text " ", :size => 13, :spacing => 4
    pdf.font "Helvetica" , :size => 6
    pdf.text "SALDO INICIAL :" << sprintf("%.2f",@viatico.inicial) ,:style => :bold;
          
      headers = []
      table_content = []

      Viatico::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
  
       for  product in @viatico.get_viaticos() 
            row = []
            
            row << nroitem.to_s        
            row << product.fecha.strftime("%d/%m/%Y") 
            row << product.tranportorder.employee.full_name   
            
            if product.supplier 
              row << product.supplier.name 
            else
              row << product.employee.full_name
            end 
            
            lccompro = product.tm << " "<<  product.descrip 
            row << lccompro 
            
            if product.tm.to_i != 6
                row << " "
                row << sprintf("%.2f",product.importe)
    
            else
              row << sprintf("%.2f",product.importe)
              
            
            end
            if product.tm.to_i != 6
              lcDato = product.tranportorder.code << " - " << product.tranportorder.truck.placa<<" - " << product.tranportorder.get_placa(product.tranportorder.truck2_id)
              row << lcDato 
              row << product.detalle
              
              row << product.tranportorder.get_punto(product.tranportorder.ubication_id)
            else
              row << " "
              row << " "
              row << " "
              row << " "
                
            end 
            table_content << row
            nroitem=nroitem + 1      
        end

       

      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left 
                                          columns([2]).align=:left                                          
                                          columns([3]).align=:right 
                                          columns([4]).align=:right 
                                          columns([5]).align=:right 
                                          columns([6]).align=:left  
                                          columns([7]).align=:right 
                                    
                                        end

      pdf.move_down 10  
      pdf

    end


    def build_pdf_footer(pdf)

   

   $lcIngreso  = sprintf("%.2f",@viatico.total_ing.round(2).to_s)  
   $lcEgreso   = sprintf("%.2f",@viatico.total_egreso.round(2).to_s)  
   $lcSaldo   = sprintf("%.2f",@viatico.saldo.round(2).to_s)  

      data0 = [[" "," "," "," ","TOTALES INGRESOS => ",$lcIngreso ],
               [" "," "," "," ","TOTALES EGRESOS  => ",$lcEgreso],
               [" "," "," "," ","SALDO            => ",$lcSaldo]]

            
        pdf.move_down 150
        pdf.text " "
        pdf.table(data0,:cell_style=> {:border_width=>0, :width=> 90,:height => 20 })
            
       
        pdf.text ""
        pdf.text "" 
        pdf.text "OBSERVACIONES : #{@viatico.comments}", :size => 8, :spacing => 4

        
       data =[ ["Procesado Asis.Finanzas ","V.B.Contador","V.B.Administracion ","V.B. Gerente ."],
               [":",":",":",":"],
               [":",":",":",":"],
               ["Fecha:","Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          
                  
        pdf.bounding_box([0, 20], :width => 538, :height => 50) do        
        pdf.draw_text "Company: #{@viatico.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom ]

      end

      pdf
      
  end   
     
  # Export viatico to PDF

  def pdf
    @viatico = Viatico.find(params[:id])
    company =@viatico.company_id
    @company =Company.find(company)
  
    
     $lcFecha1= @viatico.fecha1.strftime("%d/%m/%Y") 
     $lcMon   = @viatico.get_moneda(1)
     $lcPay= ""
     $lcSubtotal=0
     $lcIgv=0
     $lcTotal=sprintf("%.2f",@viatico.inicial)

     $lcDetracion=0
     $lcAprobado= @viatico.get_processed 


    $lcEntrega5 =  "FECHA :"
    $lcEntrega6 =  $lcFecha1

    Prawn::Document.generate("app/pdf_output/#{@viatico.id}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
         $lcFileName =  "app/pdf_output/#{@viatico.id}.pdf"      
        
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')


  end
  
  
  # Process an viatico
  def do_process
    @viatico = Viatico.find(params[:id])
    @viatico[:processed] = "1"
    
    @viatico.process
    
    flash[:notice] = "The viatico order has been processed."
    redirect_to @viatico
  end
  
  # Do send viatico via email
  def do_email
    @viatico = Viatico.find(params[:id])
    @email = params[:email]
    
    Notifier.viatico(@email, @viatico).deliver
    
    flash[:notice] = "The viatico has been sent successfully."
    redirect_to "/viaticos/#{@viatico.id}"
  end

  
  # Send viatico via email
  def email
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
  end
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    @total_pago1= 0
    i = 0
    total = 0 
    
    for item in items
      if item != ""
        parts = item.split("|BRK|")
     
        id = parts[0]
        quantity = parts[1]
        detalle  = parts[2]
        tm       = parts[3]
        inicial  = parts[4].to_f
        compro   = parts[5]
        fecha    = parts[6]
       
        product = Tranportorder.find(id.to_i)
        product[:i] = i
        product[:importe] = quantity.to_f
        product[:detalle] = detalle
        product[:tm] = tm
        product[:comprobante] = compro
        product[:fecha] = fecha 
        
        if tm.to_i == 6
          total += product[:importe]
        else
          total -= product[:importe]
        end
        product[:CurrTotal] = total
        
        @total_pago1  = total     
        
        if inicial != nil
          @diferencia =  inicial + total 
        else
          @diferencia =  total 
        end
        
        @products.push(product)
        
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  # Autocomplete for documento
  def ac_documentos
    @products = Compro.where(["company_id = ? AND code LIKE ? ", params[:company_id], "%" + params[:q] + "%"])
    
    render :layout => false
  end
  # Autocomplete for documento
  def ac_osts
    @ost = Tranportorder.where(["company_id = ? AND code LIKE ? ", params[:company_id], "%" + params[:q] + "%"])
  
    render :layout => false
  end
  # Autocomplete for employees
  def ac_employees
    @employees= Employee.where(["active= '1' and company_id = ? AND full_name ilike ? or idnumber LIKE ? ", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
  
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
    @suppliers =  Supplier.where(["company_id = ? AND (ruc LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show viaticos for a company
  def list_viaticos
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Viaticos"
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
         @viaticos = Viatico.all.order('id DESC').paginate(:page => params[:page])
        if params[:search]
          @viaticos = Viatico.search(params[:search]).order('id DESC').paginate(:page => params[:page])
        else
          @viaticos = Viatico.all.order('id DESC').paginate(:page => params[:page]) 
        end
    
    else
      errPerms()
    end
  end
  
  # GET /viaticos
  # GET /viaticos.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'viaticos'
    @pagetitle = "viaticos"
  end

  # GET /viaticos/1
  # GET /viaticos/1.xml
  def show
    @viatico = Viatico.find(params[:id])
  end

  # GET /viaticos/new
  # GET /viaticos/new.xml
  
  

  def new
    @pagetitle = "New viatico"
    @action_txt = "Create"
    
    @viatico = Viatico.new
    @viatico[:code] = "I_#{generate_guid()}"
    @viatico[:processed] = "0"
    
    @company = Company.find(params[:company_id])
    @viatico.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    
    @gastos = Gasto.order(:descrip)
    
    @ac_user = getUsername()
    @viatico[:user_id] = getUserId()
  end

  def new2
    @pagetitle = "Nuevo Viatico"
    @action_txt = "Create"
    
    @viatico = Viatico.new
    
    
    @company = Company.find(params[:company_id])

    @viatico.company_id = @company.id    
   
  end


  # GET /viaticos/1/edit
  def edit
    @pagetitle = "Edit viatico"
    @action_txt = "Update"
    
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
    
    @ac_user = @viatico.user.username
    
    @documents = @company.get_documents()
    @cajas = Caja.all 
    @gastos = Gasto.order(:descrip)
    
    
    @viaticos_lines = @viatico.viaticos_lines
    
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /viaticos
  # POST /viaticos.xml
  def create
    @pagetitle = "Nuevo viatico"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @viatico = Viatico.new(viatico_params)
    
    @company = Company.find(params[:viatico][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @gastos = Gasto.all
    
    begin
      @viatico[:inicial] = @viatico.get_total_inicial(items)
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ing(items)
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_sal(items)
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]
    
    if(params[:viatico][:user_id] and params[:viatico][:user_id] != "")
      curr_seller = User.find(params[:viatico][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @viatico.save
        # Create products for kit
        @viatico.add_products(items)        
        # Check if we gotta process the viatico
        @viatico.process()
        
        format.html { redirect_to(@viatico, :notice => 'viatico was successfully created.') }
        format.xml  { render :xml => @viatico, :status => :created, :location => @viatico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @viatico.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /viaticos/1
  # PUT /viaticos/1.xml
  def update
    @pagetitle = "Edit viatico"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @viatico = Viatico.find(params[:id])
    @company = @viatico.company
    
  
   @company = Company.find(params[:viatico][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @gastos = Gasto.order(:descrip)
    
    begin
      @viatico[:inicial] = @viatico.get_total_inicial(items)
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ing(items)
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_sal(items)
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]
    
    if(params[:viatico][:user_id] and params[:viatico][:user_id] != "")
      curr_seller = User.find(params[:viatico][:user_id])
      @ac_user = curr_seller.username
    end
     respond_to do |format|
      if @viatico.update_attributes(viatico_params)
        # Create products for kit
        @viatico.delete_products()
        @viatico.add_products(items)
        
        # Check if we gotta process the viatico
        @viatico.process()
        
        format.html { redirect_to(@viatico, :notice => 'viatico was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @viatico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticos/1
  # DELETE /viaticos/1.xml
  def destroy
    @viatico = Viatico.find(params[:id])
    company_id = @viatico[:company_id]
    @viatico.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/viaticos/" + company_id.to_s) }
    end
  end
  private
  def viatico_params
    params.require(:viatico).permit(:code, :fecha1, :inicial, :total_ing, :total_egreso, :saldo, :comments, :user_id, :company_id, :processed,:caja_id)
  end

end

