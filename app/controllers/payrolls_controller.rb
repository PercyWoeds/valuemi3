class PayrollsController < ApplicationController
  before_action :set_payroll, only: [:show, :edit, :update, :destroy,:do_pdf]

  # GET /payrolls
  # GET /payrolls.json
  def index

    @payrolls = Payroll.all
    
  end

  # GET /payrolls/1
  # GET /payrolls/1.json
  def show
  
    @payroll_details= @payroll.payroll_details.includes(:employee).order('employees.lastname ')
  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new
    @type_payrolls = TypePayroll.all 
    @payroll.fecha = Date.today 
    @parameter = Parameter.all 
    @payroll.fecha_inicial = Date.today 
    @payroll.fecha_final = Date.today 
    @payroll.fecha_pago = Date.today 
   
  end

  # GET /payrolls/1/edit
  def edit
    @type_payrolls = TypePayroll.all 
    @parameter = Parameter.all  
  end

  # POST /payrolls
  # POST /payrolls.json
  def create
    @payroll = Payroll.new(payroll_params)
    @parameter = Parameter.all 
    @payroll.company_id = 1
    @payroll.user_id = current_user.id 
    
    respond_to do |format|
      if @payroll.save
        format.html { redirect_to @payroll, notice: 'Payroll was successfully created.' }
        format.json { render :show, status: :created, location: @payroll }
      else
        format.html { render :new }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payrolls/1
  # PATCH/PUT /payrolls/1.json
  def update
    
    @type_payrolls = TypePayroll.all 
    @parameter = Parameter.all
    @payroll.company_id = 1
    @payroll.user_id = current_user.id 
    
    respond_to do |format|
      if @payroll.update(payroll_params)
        format.html { redirect_to @payroll, notice: 'Payroll was successfully updated.' }
        format.json { render :show, status: :ok, location: @payroll }
      else
        format.html { render :edit }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrolls/1
  # DELETE /payrolls/1.json
  def destroy
    @payroll.destroy
    respond_to do |format|
      format.html { redirect_to payrolls_url, notice: 'Payroll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def do_process 
    
    @payroll = Payroll.find(params[:id])
    @payroll.process
    @user_id = @current_user.id 
    flash[:notice] = "La planilla ha sido procesada."
    redirect_to @payroll 
    
  end 
  def do_update
  
    
    @payroll = Payroll.find(params[:id])
    @payroll.actualizar 
    @user_id = @current_user.id 
    flash[:notice] = "La planilla ha sido procesada."
    redirect_to @payroll 
    
  end 
  
  def build_pdf_header(pdf)
     pdf 
     
  end 
  

  def build_pdf_body(pdf)
    
   
      headers = []
      table_content = []
     
      nroitem=1

       for  bp in @payroll_details
       
       cell_1 =  bp.employee.full_name
       $lcCodigo = bp.employee.idnumber
       $lcTrabajador =  bp.employee.full_name
       $lcCategoria = "EMPLEADO"
       $lcArea = bp.employee.division.name 
       $lcCargo = bp.employee.ocupacion.name 
       $lcCCosto= "SERVICIOS"
       $lcDni =  bp.employee.idnumber.to_s 
       $lcFecNac = bp.employee.fecha_nacimiento.strftime("%d/%m/%Y")
       $lcSitEspecial ="NINGUNO"
       
       if bp.employee.onp == "1" 
          $lcAfp = "ONP"
       else
          if bp.employee.afp == nil
            $lcAfp = ""
          else 
            $lcAfp = bp.employee.afp.name 
          end 
       end 
       
       if bp.employee.fecha_ingreso != nil
          $FecIngreso = bp.employee.fecha_ingreso.strftime("%d/%m/%Y")
       else
          $FecIngreso = ""    
        end
       if bp.employee.fecha_cese != nil
          $FecCese = bp.employee.fecha_cese.strftime("%d/%m/%Y")
        else
          $FecCese = ""    
        end
       $lcDias = bp.dias
       $lcSubs = bp.subsidio 
       $lcFalta = bp.falta 
       $lcVaca = bp.vaca 
       $lcRemMensual = bp.employee.sueldo.to_s 
       
       
       
      dell_1 =pdf.make_cell(:content => "")
      dell_2 =pdf.make_cell(:content => "INGRESO ") 
      dell_3 =pdf.make_cell(:content => "")
      dell_4 =pdf.make_cell(:content => "") 
      dell_5 =pdf.make_cell(:content => "DESCUENTOS")
      dell_6 =pdf.make_cell(:content => "")
      dell_7 =pdf.make_cell(:content => "APORTACIONES EMPLEADOR")
      
      #DETALLE BOLETAS
      # fila 1
      
      
      
      $lcSueldoBasico = bp.basico.to_s
      
      if bp.employee.onp == "1"
        
        $lcOnp = bp.calc5.to_s
      else
        
        $lcAporteAfp   = bp.aporte.to_s
        $lcSeguroAfp   = bp.seguro.to_s
        $lcComisionAfp = bp.comision.to_s
      end 
        
        $lcEssalud  = bp.total3.to_s
        
      #fila 2
      
      if bp.calc1 > 0 
      
      $lcAsignacionFamiliar = bp.calc1.to_s
      else 
      $lcAsignacionFamiliar = ""  
      end 
      
      
        
        if bp.hextra0 > 0
        
         $lcHorasExtras = bp.hextra0.to_s
        else
         $lcHorasExtras = ""    
        end 
            
      #fila 4
     
     
        
        if bp.vaca > 0
          
          $lcVaca = bp.vacaciones.to_s
        else 
          $lcVaca = "" 
        end 
         
        if bp.calc4 > 0 
          $lcQuinta =  bp.calc4.to_s
        else
          $lcQuinta = ""
        end 
        
        
        if bp.desmed > 0
          $lcDesMed = bp.desmedico.to_s
        else
          $lcDesMed = ""
          
        end 
        if bp.faltas >0       
           $lcFaltas = bp.faltas.to_s
        else
           $lcFaltas = 0
        end 
        
      #fila 6
      
        
        if bp.subsidio > 0
          $lcSubsidio = bp.subsidio0.to_s
        else
          $lcSubsidio = ""
        end
        
        if bp.calc7 > 0
          $lcAdelanto =  bp.calc7.to_s
        else
          $lcAdelanto = ""  
        end 
        
      #fila 7
      
        
        if bp.otros > 0 
        
          $lcOtros = bp.otros.to_s
        else
          $lcOtros = ""
        end 
          
        
       
      texto = "PLANILLA : " << @payroll.code
       pdf.table([["TRANSPORTES PEREDA SRL ","","", "","DS.Nro.020 -2008"],
       ["RUC: 20424092941", "BOLETAS  DE REMUNERACIONES ","",""," ",texto ]], {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        })
        
        ###
      max_rows = [client_data_headers_1.length, invoice_headers_1.length,invoice_headers_2.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers_1.length >= row ? client_data_headers_1[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_1.length >= row ? invoice_headers_1[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_2.length >= row ? invoice_headers_2[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width,
          
        }) do
          
          columns([0,2,4]).font_style = :bold
           rows(0..-1).each do |r|
            r.height = 15
          end
          
        end
        
       
        end
        
        ###
        pdf.stroke_horizontal_rule
        
        pdf.table(
      [[dell_1 ,dell_2,dell_3,dell_4,dell_5,dell_6,dell_7] 
       ],
       {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width,
          :column_widths => {0 => 50}
        }  )
       pdf.stroke_horizontal_rule
       
      #DETALLE 
       max_rows = [boleta_1.length, boleta_2.length,boleta_3.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (boleta_1.length >= row ? boleta_1[rows_index] : ['',''])
        rows[rows_index] += (boleta_2.length >= row ? boleta_2[rows_index] : ['',''])
        rows[rows_index] += (boleta_3.length >= row ? boleta_3[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 1},
          :width => pdf.bounds.width,
          
        }) do
          
           rows(0..-1).each do |r|
            r.height = 15
          end
          
        end
        
       
        end
      
        
      pdf.move_down 40
      pdf.stroke_horizontal_rule
      
      
      tell_1 =pdf.make_cell(:content => "TOTAL HABERES.")
      tell_2 =pdf.make_cell(:content => "") 
      tell_3 =pdf.make_cell(:content => bp.totingreso.to_s)
      tell_4 =pdf.make_cell(:content => "TOTAL DSCTOS.") 
      tell_5 =pdf.make_cell(:content => bp.total2.to_s)
      tell_6 =pdf.make_cell(:content => "NETO")
      tell_7 =pdf.make_cell(:content => bp.remneta.to_s)
      
      
      
        pdf.table(
      [[tell_1,tell_2,tell_3,tell_4,tell_5,tell_6,tell_7] 
       ],
       {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        })
      
            pdf.stroke_horizontal_rule
            
            pdf.move_down 20      
    end 
       
     
       pdf

    end


    def build_pdf_footer(pdf)

        pdf.text ""
        pdf.text "" 
        pdf 
    end
      
  def client_data_headers_1
     lcdir1=""
      client_headers  = [["Código  :", $lcCodigo]]
      client_headers << ["Trabajador :", $lcTrabajador]
      client_headers << ["Tipo/Categoria Trabajador :", $lcCategoria]
      client_headers << ["Area :", $lcArea]     
      client_headers << ["Centro de Costos :",$lcCCosto]     
      client_headers << ["Cargo :", $lcCargo] 
      client_headers << ["Tipo Documento :", $lcDni ] 
      client_headers << ["Fecha Nacimiento :", $lcFecNac ] 
      client_headers << ["Regimen Laboral  :", "PRIVADOR GENERAL D LEG N.728 " ] 
      client_headers
  end

  def invoice_headers_1
      invoice_headers  = [["Fecha Ingreso     : ",$FecIngreso ]]    
      invoice_headers << ["Fecha Cese         : ",$FecCese ]
      invoice_headers << ["Periodo Vacacional : ","-"]
      invoice_headers << ["   Inicio Vac.:",""]
      invoice_headers << ["   Fin Vac.   :",""]
      invoice_headers << ["Rég.Pensionario    : ",$lcAfp]
      invoice_headers << ["C.U.S.P.P.         : ",""]
      invoice_headers << ["Autogenerado       : ",""]
      invoice_headers << ["Sit.Especial       : ",$lcSitEspecial ]
      invoice_headers
  end
  def invoice_headers_2
      invoice_headers2  = [["Dias Lab.       : ",$lcDias ]]    
      invoice_headers2 << ["Dias Subs.      : ",$lcSubs ]
      invoice_headers2 << ["Dias No Lab.    : ",$lcFalta]
      invoice_headers2 << ["Dias Vac.       : ",$lcVaca]
      invoice_headers2 << ["N.Horas Ord.    : ",""]
      invoice_headers2 << ["N.Hs.Ext.25%    : ",""]
      invoice_headers2 << ["N.Hs.Ext.35%    : ",""]
      invoice_headers2 << ["N.Hs.Ext.100%   : ",""]
      invoice_headers2 << ["Rem.Mensual     : ",$lcRemMensual]
      invoice_headers2
  end
  
  def boleta_1
      boleta_headers1  = [["Remuneración Basica  : ",$lcRemBasico ]]    
      boleta_headers1 << ["Asignacion Familiar   : ",$lcAsignacion ]
      boleta_headers1 << ["Vacaciones            : ","-"]
      boleta_headers1 << ["Descanso Med..        :",""]
      boleta_headers1 << ["Subsidio              :",""]
      boleta_headers1 << ["Reintegro             : ",$lcAfp]
      boleta_headers1 << [" ",""]
      boleta_headers1 << [" ",""]
      boleta_headers1 << [" ",$lcSitEspecial ]
      boleta_headers1
  end 
  
  def boleta_2
      boleta_headers2 = [["AFP Aporte Obligatorio  : ",$lcRemBasico ]]    
      boleta_headers2 << ["ONP                     : ",$lcAsignacion ]
      boleta_headers2 << ["AFP Seguro de Vida      : ",$lcAsignacion ]
      boleta_headers2 << ["AFP Comision sobre la RA: ","-"]
      boleta_headers2 << ["Inasistencia        :",""]
      boleta_headers2 << ["Quinta Categoria              :",""]
      boleta_headers2 << ["Adelantos ",""]
      boleta_headers2 << ["Otros  ",""]
      boleta_headers2 << [" ","" ]
      boleta_headers2
  end 
  def boleta_3
      boleta_headers3 = [["Essalud  : ",$lcRemBasico ]]    
      boleta_headers3 << ["","" ]
      boleta_headers3 << ["","-"]
      boleta_headers3 << ["",""]
      boleta_headers3 << ["",""]
      boleta_headers3 << ["",""]
      boleta_headers3 << ["",""]
      boleta_headers3 << [" ",""]
      boleta_headers3 << [" ","" ]
      boleta_headers3
  end 
  
  

  def do_pdf
      @payroll_details= @payroll.payroll_details
      @user_id = @current_user.id 
  
    Prawn::Document.generate("app/pdf_output/#{@payroll.id}.pdf") do |pdf|
        pdf.font "Helvetica" , :size => 6
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@payroll.id}.pdf"     
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  # example 
  
    
    
    
  end 
  

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
    
    pdf.text "Planilla Emitida : ", :size => 8 
    pdf.text "Fecha inicial : "+@payroll.fecha_inicial.strftime("%d/%m/%Y").to_s
    pdf.text "Fecha final : "+@payroll.fecha_final.strftime("%d/%m/%Y").to_s
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Payroll::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcDoc='FT'
      lcsubtotal =  0
      lctax = 0
      lctotal = 0
            total_remuneracion = 0
            total_totaldia = 0
            total_falta =0
            total_vaca = 0
            total_desmed = 0
            total_subsidio = 0
            total_hextra  = 0
            total_dias =  0
            total_basico= 0
            total_calc1  = 0
            total_hextra0  = 0
            total_vacaciones = 0
            total_desmedico = 0
            total_subsidio0 = 0
            total_reintegro= 0
            total_totingreso= 0
            total_total1 = 0
            total_calc5= 0
            total_aporte = 0
            total_seguro = 0
            total_comision = 0
            total_calc4 = 0
            total_faltas = 0
            total_calc7 = 0
            total_otros = 0
            total_total2= 0
            total_remneta = 0
            total_calc8= 0
            total_total3 = 0
        
      

       for  detalle  in @planilla 

            row = []          
            nombre2 = detalle.employee.lastname << detalle.employee.firstname
            row << nroitem.to_s
            row << detalle.employee.fecha_ingreso.strftime("%d/%m/%Y")
            row << detalle.employee.idnumber.to_s 
            row << nombre2

             if detalle.employee.division != nil
            row << detalle.employee.division.name
            else
            row << "null"
            end 
            
            if detalle.employee.ocupacion != nil
            row << detalle.employee.ocupacion.name
          else
            row << "no def"
          end 
            
            if detalle.employee.onp == "0"
              if detalle.employee.afp != nil
              row << detalle.employee.afp.name
                  if detalle.employee.comision_flujo == 1
                  row << "FLUJO"
                  elsif  detalle.employee.comision_flujo == 2
                    row << "MIXTA"
                  elsif  detalle.employee.comision_flujo == 3
                    row << "FLUJO MIXTA"
                  else
                     row << "NINGUNO"  
                     row << ""
                  end 
              else
                row << "null"
                row << ""
              end
            else
              row << "ONP"
              row << ""
            end 
            
            row << detalle.remuneracion 
            row << detalle.totaldia
            row << detalle.falta
            row << detalle.vaca
            row << detalle.desmed 
            row << detalle.subsidio
            row << detalle.hextra
            row << detalle.dias
            row << detalle.basico
            row << detalle.calc1 
            row << detalle.hextra0 
            row << detalle.vacaciones
            row << detalle.desmedico
            row << detalle.subsidio0 
            row << detalle.reintegro
            row << detalle.totingreso
            row << detalle.total1 
            row << detalle.calc5
            row << detalle.aporte
            row << detalle.seguro 
            row << detalle.comision 
            row << detalle.calc4 
            row << detalle.faltas 
            row << detalle.calc7 
            row << detalle.otros 
            row << detalle.total2
            row << detalle.remneta 
            row << detalle.calc8
            row << detalle.total3 
        
        total_remuneracion += detalle.remuneracion
            total_totaldia += detalle.totaldia
            total_falta += detalle.falta
            total_vaca += detalle.vaca
            total_desmed += detalle.desmed
            total_subsidio += detalle.subsidio
            total_hextra  += detalle.hextra
            total_dias += detalle.dias
            total_basico += detalle.basico
            total_calc1  += detalle.calc1
            total_hextra0  += detalle.hextra0
            total_vacaciones += detalle.vacaciones
            total_desmedico += detalle.desmedico
            total_subsidio0 += detalle.subsidio0
            total_reintegro += detalle.reintegro
            total_totingreso += detalle.totingreso
            total_total1 += detalle.total1
            total_calc5 += detalle.calc5
            total_aporte +detalle.aporte
            total_seguro += detalle.seguro
            total_comision += detalle.comision
            total_calc4 += detalle.calc4
            total_faltas += detalle.faltas
            total_calc7 += detalle.calc7
            total_otros += detalle.otros 
            total_total2 += detalle.total2
            total_remneta += detalle.remneta
            total_calc8 += detalle.calc8
            total_total3 += detalle.total3
        
            
            table_content << row

            nroitem=nroitem + 1
       
        end
        
            row = []
            row << ""
            row << ""
            row << ""
            row << "TOTALES => "
            row << ""
            row << ""
            row << ""
            row << ""
            row << total_remuneracion.round(2) 
            row << total_totaldia.round(2)
            row << total_falta.round(2)
            row << total_vaca.round(2)
            row << total_desmed.round(2) 
            row << total_subsidio.round(2)
            row << total_hextra.round(2)
            row << total_dias.round(2)
            row << total_basico.round(2)
            row << total_calc1.round(2) 
            row << total_hextra0.round(2) 
            row << total_vacaciones.round(2)
            row << total_desmedico.round(2)
            row << total_subsidio0.round(2) 
            row << total_reintegro.round(2)
            row << total_totingreso.round(2)
            row << total_total1.round(2) 
            row << total_calc5.round(2)
            row << total_aporte.round(2)
            row << total_seguro.round(2)
            row << total_comision.round(2) 
            row << total_calc4.round(2) 
            row << total_faltas.round(2) 
            row << total_calc7.round(2) 
            row << total_otros.round(2) 
            row << total_total2.round(2)
            row << total_remneta.round(2) 
            row << total_calc8.round(2)
            row << total_total3.round(2) 
            table_content << row
        

        result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:left
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([5]).align=:left  
                                          columns([6]).align=:left
                                          columns([7]).align=:left
                                          columns([8]).align=:right
                                          columns([9]).align=:right
                                          columns([10]).align=:center
                                          columns([11]).align=:left
                                          columns([12]).align=:left
                                          columns([13]).align=:right
                                          columns([14]).align=:right
                                          columns([15]).align=:right  
                                          columns([16]).align=:right
                                          columns([17]).align=:right
                                          columns([18]).align=:right
                                          columns([19]).align=:right
                                          columns([20]).align=:right
                                          columns([21]).align=:right
                                          columns([22]).align=:right
                                          columns([23]).align=:right
                                          columns([24]).align=:right
                                          
                                        end                                          
      pdf.move_down 10      

      #totales 

      pdf 

    end

    def build_pdf_footer_rpt(pdf)
      
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end

def do_pdf2
     @company = Company.find(1)
     @payroll = Payroll.find(params[:id])
     @planilla = PayrollDetail.where(payroll_id: @payroll.id).includes(:employee).order('employees.lastname ')    

  render  pdf: "Boleta",template: "payrolls/boleta_rpt.pdf.erb",locals: {:payroll => @planilla}
  
  
          Prawn::Document.generate "app/pdf_output/rpt_planilla.pdf" , :page_layout => :landscape,:page_size => "A2" do |pdf|        
             pdf.font "Helvetica"
             pdf = build_pdf_header_rpt(pdf)
             pdf = build_pdf_body_rpt(pdf)
             build_pdf_footer_rpt(pdf)
             $lcFileName =  "app/pdf_output/rpt_planilla.pdf"              
         end     
         $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
         send_file("app/pdf_output/rpt_planilla.pdf", :type => 'application/pdf', :disposition => 'inline')

  end
  def do_pdf3
     @company = Company.find(1)
     @payroll = Payroll.find(params[:id])
     @planilla = PayrollDetail.where(payroll_id: @payroll.id).includes(:employee).order('employees.lastname ')    
     render  pdf: "Boleta",template: "payrolls/boleta_rpt.pdf.erb",locals: {:payroll => @planilla}
  
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
 
  def invoice_summary
      invoice_summary = []
      invoice_summary << ["Sueldo Neto ",  ActiveSupport::NumberHelper::number_to_delimited($lcRemNeta,delimiter:",",separator:".").to_s]
      invoice_summary
  end


  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_params
      params.require(:payroll).permit(:code, :type_payroll_id, :fecha, :fecha_inicial, :fecha_final, :fecha_pago,:parameter_id)
    end
end
