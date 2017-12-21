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
       
       cell_1 = pdf.make_cell(:content => " NOMBRE : "<< bp.employee.full_name)
       cell_2 = pdf.make_cell(:content => "SUELDO: " << bp.remuneracion.to_s)
       
       cell_3 = pdf.make_cell(:content => "CODIGO: " << bp.employee_id.to_s)
       cell_4 = pdf.make_cell(:content => "AGENCIA: " << bp.employee.location.name)
       cell_5 = pdf.make_cell(:content => "DIAS LAB.: " << bp.totaldia.to_s)
       cell_6 = pdf.make_cell(:content => "DIAS FALTA :"<< bp.falta.to_s)
       
       cell_7 = pdf.make_cell(:content => "DNI: " << bp.employee.idnumber.to_s)
       cell_8 = pdf.make_cell(:content => "SECCION: " << bp.employee.division.name)
       cell_9 = pdf.make_cell(:content => "REG. LAB.: " << bp.employee_id.to_s)
       cell_10 = pdf.make_cell(:content => "D.N.LAB. :")
       cell_11 = pdf.make_cell(:content => "SUBS. :")
       
       cell_12 = pdf.make_cell(:content => "F.INGRESO: " << bp.employee.fecha_ingreso.strftime("%d/%m/%Y"))
       cell_13 = pdf.make_cell(:content => "OCUPACION: " << bp.employee.ocupacion.name)
       cell_14 = pdf.make_cell(:content => "TRABAJADOR DE.: " )
       cell_15 = pdf.make_cell(:content => "HS.EXTRA. :"<< bp.hextra.to_s)
       cell_16 = pdf.make_cell(:content => "HS.EXTRA. :" )
       if bp.employee.fecha_cese != nil
       cell_16 = pdf.make_cell(:content => "F.CESE: " << bp.employee.fecha_cese.strftime("%d/%m/%Y"))
        else
          cell_16 = pdf.make_cell(:content => "F.CESE: " )
        end
       #cell_17 = pdf.make_cell(:content => "TIPO DE TRAB.: " << bp.employee.categorium.descrip)
       cell_17=""
       cell_18 = pdf.make_cell(:content => "DIAS.VACAC.: " << bp.vaca.to_s)
       
       cell_19 = pdf.make_cell(:content => "DESCANSO MEDICO : " << bp.desmed.to_s)
       cell_20 = pdf.make_cell(:content => "SUBSIDIO : " << bp.subsidio.to_s)
       cell_21 = pdf.make_cell(:content => "FALTAS : "<< bp.falta.to_s)
      
       
       
      dell_1 =pdf.make_cell(:content => "DIAS/HRS.")
      dell_2 =pdf.make_cell(:content => "") 
      dell_3 =pdf.make_cell(:content => "HABERES")
      dell_4 =pdf.make_cell(:content => "") 
      dell_5 =pdf.make_cell(:content => "DESCUENTO")
      dell_6 =pdf.make_cell(:content => "")
      dell_7 =pdf.make_cell(:content => "APORTACIONES")
      
      #DETALLE BOLETAS
      # fila 1
      
      dell_8 =pdf.make_cell(:content => bp.dias.to_s)
      dell_9 =pdf.make_cell(:content => "SUELDO BASICO  ") 
      dell_10 =pdf.make_cell(:content => bp.basico.to_s)
      
      if bp.employee.onp == "1"
        dell_11 =pdf.make_cell(:content => "ONP") 
        dell_12 =pdf.make_cell(:content => bp.calc5.to_s)
      else
        dell_11 =pdf.make_cell(:content => "AFP LEY 10%") 
        dell_12 =pdf.make_cell(:content => bp.aporte.to_s)
      end 
        
        dell_13 =pdf.make_cell(:content => "ESSALUD")
        dell_14 =pdf.make_cell(:content => bp.total3.to_s)
        
      #fila 2
      dell_15 =pdf.make_cell(:content => "")
      if bp.calc1 > 0 
      dell_16 =pdf.make_cell(:content => "ASIG.FAMILIAR") 
      dell_17 =pdf.make_cell(:content => bp.calc1.to_s)
      else 
      dell_16 =pdf.make_cell(:content => "") 
      dell_17 =pdf.make_cell(:content => "")
        
      end 
      if bp.employee.onp == "1"
        dell_18 =pdf.make_cell(:content => "") 
        dell_19 =pdf.make_cell(:content => "")
      else
        dell_18 =pdf.make_cell(:content => "AFP SEGURO ") 
        dell_19 =pdf.make_cell(:content => bp.seguro.to_s)
      end 

        dell_20 =pdf.make_cell(:content => "")
        dell_21 =pdf.make_cell(:content => "")
      #fila 3  
      
        dell_22 =pdf.make_cell(:content => "")
        
        if bp.hextra0 > 0
        dell_23 =pdf.make_cell(:content => "HORAS EXTRAS") 
        dell_24 =pdf.make_cell(:content => bp.hextra0.to_s)
        else
        dell_23 =pdf.make_cell(:content => "") 
        dell_24 =pdf.make_cell(:content => "")
          
        end 
            
      
      if bp.employee.onp == "1"
        dell_25 =pdf.make_cell(:content => "") 
        dell_26 =pdf.make_cell(:content => "")
      else
        dell_25 =pdf.make_cell(:content => "AFP COMISION.") 
        dell_26 =pdf.make_cell(:content => bp.comision.to_s)
      end 
          
          
        dell_27 =pdf.make_cell(:content => "")
        dell_28 =pdf.make_cell(:content => "")
      
      #fila 4
      
        dell_29 =pdf.make_cell(:content => "")
        
        if bp.vaca > 0
          dell_30 =pdf.make_cell(:content => "VACACIONES:") 
          dell_31 =pdf.make_cell(:content => bp.vacaciones.to_s)
        else 
          dell_30 =pdf.make_cell(:content => "") 
          dell_31 = pdf.make_cell(:content => "") 
        end 
      
        dell_32 =pdf.make_cell(:content => "5TA.CATEGORIA") 
        dell_33 =pdf.make_cell(:content => bp.calc4.to_s)
        
        dell_34 =pdf.make_cell(:content => "")
        dell_35 =pdf.make_cell(:content => "")
      #fila 5
      
        dell_36 =pdf.make_cell(:content => "")
        if bp.desmed > 0
          dell_37 =pdf.make_cell(:content => "DES.MEDICO") 
          dell_38 =pdf.make_cell(:content => bp.desmedico.to_s)
        else
          dell_37 =pdf.make_cell(:content => "") 
          dell_38 =pdf.make_cell(:content => "")
        end 
      
        dell_39 =pdf.make_cell(:content => "FALTAS") 
        dell_40 =pdf.make_cell(:content => bp.faltas.to_s)
        
        dell_41 =pdf.make_cell(:content => "")
        dell_42 =pdf.make_cell(:content => "")
      
      #fila 6
      
        dell_43 =pdf.make_cell(:content => "")
        if bp.subsidio > 0
          dell_44 =pdf.make_cell(:content => "SUBSIDIO:") 
          dell_45 =pdf.make_cell(:content => bp.subsidio0.to_s) 
        else
          dell_44 =pdf.make_cell(:content => "") 
          dell_45 =pdf.make_cell(:content => "")
        end
        dell_46 =pdf.make_cell(:content => "ADELANTO") 
        dell_47 =pdf.make_cell(:content => bp.calc7.to_s)
        
        dell_48 =pdf.make_cell(:content => "")
        dell_49 =pdf.make_cell(:content => "")
      #fila 7
      
        
        dell_50 =pdf.make_cell(:content => "") 
        dell_51 =pdf.make_cell(:content => "")
        dell_52 =pdf.make_cell(:content => "")
        
        dell_53 =pdf.make_cell(:content => "OTROS")
        dell_54 =pdf.make_cell(:content => bp.otros.to_s)
        
        dell_55 =pdf.make_cell(:content => "")
        dell_56 =pdf.make_cell(:content => "")
      #fila 8
      
        
        dell_57 =pdf.make_cell(:content => "") 
        dell_58 =pdf.make_cell(:content => "")
        dell_59 =pdf.make_cell(:content => "") 
        
        dell_60 =pdf.make_cell(:content => "")
        dell_61 =pdf.make_cell(:content => "")
        
        dell_62 =pdf.make_cell(:content => "")
        dell_63 =pdf.make_cell(:content => "")
      #fila 9
      
        
        dell_64 =pdf.make_cell(:content => "") 
        dell_65 =pdf.make_cell(:content => "")
        dell_66 =pdf.make_cell(:content => "")
        
        dell_67 =pdf.make_cell(:content => "")
        dell_68 =pdf.make_cell(:content => "")
        
        dell_69 =pdf.make_cell(:content => "")
        dell_70 =pdf.make_cell(:content => "")
      #fila 10
      
        
        dell_71 =pdf.make_cell(:content => "") 
        dell_72 =pdf.make_cell(:content => "")
        dell_73 =pdf.make_cell(:content => "")
        
        dell_74 =pdf.make_cell(:content => "")
        dell_75 =pdf.make_cell(:content => "")
        
        dell_76 =pdf.make_cell(:content => "")
        dell_77 =pdf.make_cell(:content => "")
      
      
       pdf.table([["TRANSPORTES PEREDA SRL ","JR VICTOR REINEL 185 LIMA ","", "BOLETA NRO."],
       ["RUC: 20424092941", "", "D.S.001-98-TR", "PERIODO DE PAGO :"],
       [cell_1, "", "",cell_2],
       [cell_3,cell_4,cell_5,cell_6],
       [cell_7,cell_8,cell_9,cell_10,cell_11],
       [cell_12,cell_13,cell_14,cell_10,cell_15],
       [cell_16,cell_17,"","",cell_18],
       [cell_19,cell_20,cell_21,"",""]], {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        })
        
        
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
       pdf.table(
      [
       [dell_8 ,dell_9,dell_10,dell_11,dell_12,dell_13,dell_14],
       [dell_15,dell_16,dell_17,dell_18,dell_19,dell_20,dell_21],
       [dell_22,dell_23,dell_24,dell_25,dell_26,dell_27,dell_28],
       [dell_29,dell_30,dell_31,dell_32,dell_33,dell_34,dell_35],
       [dell_36,dell_37,dell_38,dell_39,dell_40,dell_41,dell_42],
       [dell_43,dell_44,dell_45,dell_46,dell_47,dell_48,dell_49],
       [dell_50,dell_51,dell_52,dell_53,dell_54,dell_55,dell_56],
       [dell_57,dell_58,dell_59,dell_60,dell_61,dell_62,dell_63]],
       {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        })
        
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
      


  def do_pdf
      @payroll_details= @payroll.payroll_details
      @user_id = @current_user.id 
  
    Prawn::Document.generate("app/pdf_output/#{@payroll.id}.pdf") do |pdf|
      
        pdf.font_families.update("Open Sans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Italic.ttf",
        })

        pdf.font "Open Sans",:size =>7
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@payroll.id}.pdf"     
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
    
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

            row << detalle.employee.division.name
            row << detalle.employee.ocupacion.name
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
