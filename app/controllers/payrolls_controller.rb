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
    @payroll_details= @payroll.payroll_details
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
  
  def build_pdf_header(pdf)
     pdf 
     
  end 
  

  def build_pdf_body(pdf)
    
   
      headers = []
      table_content = []
     
      nroitem=1

       for  bp in @payroll_details
       
            row = []
            
              row << "Apellidos y Nombres : " 
              row <<  bp.employee.full_name
              row << " "
              row << " "
              row << " "
            table_content << row
            
            row = []
            row << "Ocupacion :"
            row << " "
            row << " "
            row << "Fec.Ingreso: "
            row <<  bp.employee.fecha_ingreso
            table_content << row
            
            row = []
            row << "Fec.Nacimiento :"
            row << bp.employee.fecha_nacimiento
            row << " "
            row << "DNI :"
            row << bp.employee.idnumber  
            table_content << row
                      
            row = []
            row << "Nro.AFP:"
            row << ""
            row << " "
            row << "Fec.Cese :"
            row << ""
            table_content << row
                      
            row = []
            row << "Inicio Vacaciones :"
            row << " "
            row << " "
            row << "Salida Vacaciones :"
            row << ""
            table_content << row
            
            row = []
            
            row << "Remuneración :"
            row << bp.remuneracion 
            row << "Essalud:"
            row << bp.calc8
            row << ""
            table_content << row
            
            row = []
            row << "Jornal :"
            row << " "
            row << "ONP:"
            row << ""
            row << bp.calc5
            table_content << row
            
            nroitem=nroitem + 1
            
        end

       cell_1 = pdf.make_cell(:content => " NOMBRE :"<< bp.employee.full_name)
       cell_2 = pdf.make_cell(:content => "SUELDO: " << bp.remuneracion.to_s)
       
       cell_3 = pdf.make_cell(:content => "CODIGO: " << bp.employee_id.to_s)
       cell_4 = pdf.make_cell(:content => "AGENCIA: " << bp.employee_id.to_s)
       cell_5 = pdf.make_cell(:content => "DIAS LAB.: " << bp.employee_id.to_s)
       cell_6 = pdf.make_cell(:content => "TARDANZA :")
       
       cell_7 = pdf.make_cell(:content => "DNI: " << bp.employee_id.to_s)
       cell_8 = pdf.make_cell(:content => "SECCION: " << bp.employee_id.to_s)
       cell_9 = pdf.make_cell(:content => "REG. LAB.: " << bp.employee_id.to_s)
       cell_10 = pdf.make_cell(:content => "D.N.LAB. :")
       cell_11 = pdf.make_cell(:content => "SUBS. :")
       
       cell_12 = pdf.make_cell(:content => "F.INGRESO: " << bp.employee_id.to_s)
       cell_13 = pdf.make_cell(:content => "OCUPACION: " << bp.employee_id.to_s)
       cell_14 = pdf.make_cell(:content => "TRABAJADOR DE.: " << bp.employee_id.to_s)
       cell_15 = pdf.make_cell(:content => "HRS.NORM. :")
       cell_16 = pdf.make_cell(:content => "HS.EXTRA. :")
       
       cell_16 = pdf.make_cell(:content => "F.CESE: " << bp.employee_id.to_s)
       cell_17 = pdf.make_cell(:content => "TIPO DE TRAB.: " << bp.employee_id.to_s)
       cell_18 = pdf.make_cell(:content => "F.INI.VACAC.: " << bp.employee_id.to_s)
       
       cell_19 = pdf.make_cell(:content => "CUSSP:")
       cell_20 = pdf.make_cell(:content => "REGIMEN PENSION. :")
       cell_21 = pdf.make_cell(:content => "F.FIN.VACAC. :")
       
       
       two_dimensional_array =[
        ["Remuneracion : "],
       ["Jornal"],
       ["Dominical"],
       ["Incremento"],
       ["Horas Extras"],
       ["Asig.familiar"],
       ["Part.Utilidades"],
       ["Feriados"],
       ["Bonificaciones."],
       ["Reintegros."],
       ["Vacaciones"],
       ["Comisiones"]  ]
      
      dell_1 =pdf.make_cell(:content => "CUSSP:")
      dell_2 =pdf.make_cell(:content => "CUSSP:") 
      dell_3 =pdf.make_cell(:content => "CUSSP:")
      dell_4 =pdf.make_cell(:content => "CUSSP:") 
      dell_5 =pdf.make_cell(:content => "CUSSP:")
      dell_6 =pdf.make_cell(:content => "CUSSP:")
      dell_7 =pdf.make_cell(:content => "CUSSP:")
      
      
       pdf.table([["TRANSPORTES PEREDA SRL ","JR VIRTOR REINEL 185 LIMA ","", "BOLETA NRO."],
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
        
        
        pdf.table(
      [[dell_1,dell_2,dell_3,dell_4,dell_5,dell_6,dell_7]], {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        })
        
       
       pdf.move_down 10      
     
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

        pdf.font "Open Sans",:size =>6
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
        $lcFileName =  "app/pdf_output/#{@payroll.id}.pdf"     
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
    send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')
  
    
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
