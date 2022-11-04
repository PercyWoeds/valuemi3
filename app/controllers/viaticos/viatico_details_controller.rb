class Viaticos::ViaticoDetailsController < ApplicationController
  
  before_action :set_viatico 
  
  before_action :set_viatico_detail, :except=> [:new,:create]

  
  # GET /viatico_details
  # GET /viatico_details.json
  def index
    @viatico_details = ViaticoDetail.all
  end

  # GET /viatico_details/1
  # GET /viatico_details/1.json
  def show
    @gastos = Gasto.all
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @employees = @company.get_employees 
    @tipomov = Tipomov.all 
  end

  # GET /viatico_details/new
  def new
    @viatico_detail = ViaticoDetail.new
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @cajas = Caja.all      
    @viatico_detail[:fecha] = Date.today 
    @viatico_detail[:fecha2] = Date.today 
    
    @destinos = Destino.all
    @employees = @company.get_employees 
    @suppliers = @company.get_suppliers 
    
    @tipomov = Tipomov.all 

    @viatico_detail[:tranportorder_id] = 1 
    @viatico_detail[:supplier_id] = 4 
    @viatico_detail[:employee_id] = 51 
    @viatico_detail[:destino_id] = 1
    
    
    
  end

  # GET /viatico_details/1/edit
  def edit
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @suppliers = @company.get_suppliers 
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 
    @tipomov = Tipomov.all 
    @transporte = Tranportorder.find(@viatico_detail.tranportorder_id)
    @ac_item = @transporte.code 
    @ac_item_id = @transporte.id
    
    if @viatico_detail.supplier_id != nil
    @supplier = Supplier.find(@viatico_detail.supplier_id)
    @ac_supplier = @supplier.name
    @ac_supplier_id = @supplier.id
    else
    @ac_supplier = ""
    @ac_supplier_id = ""
      
    end 
    
    @employee = Employee.find(@viatico_detail.employee_id)
    @ac_employee = @employee.full_name
    @ac_employee_id = @employee.id
    

  end

  # POST /viatico_details
  # POST /viatico_details.json
  def create
    
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @suppliers = @company.get_suppliers 
    @cajas = Caja.all      
    @destinos = Destino.all
    @employees = @company.get_employees 
    @tipomov = Tipomov.all 
    @viatico_detail = ViaticoDetail.new(viatico_detail_params)    
    @viatico_detail.viatico_id  = @viatico.id 
    
   
    @viatico_detail.supplier_id = params[:viatico_detail][:supplier_id]
    @viatico_detail.document_id = params[:viatico_detail][:document_id]
   
    @viatico_detail[:tranportorder_id] = 1 
    
    @viatico_detail[:employee_id] = 51
    @viatico_detail[:destino_id] = 1
    
    

    zeros =' 00:00:00'
     @viatico_detail.fecha = params[:viatico_detail][:fecha] << zeros 
    

    
     respond_to do |format|
      if @viatico_detail.save
         begin
      @viatico[:inicial] = @viatico.get_total_inicial
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ingreso
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_egreso
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]


         @viatico.save 


puts "viatico detail ***********"

       if @viatico_detail[:gasto_id] != 30

        puts "viatico ++++++++++++"

       puts @viatico_detail[:gasto_id]  

                case @viatico_detail[:document_id]


                    when 13  
                        self.update_purchase()
                    when 1
                        self.update_purchase()
                    when 2
                        self.update_purchase()
                    when 12
                        self.update_purchase()

                    when 5
                        self.update_purchase_RH()
                    end   
        end 
                  
          if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
         format.html { redirect_to @viatico, notice: 'Viatico Detalle fue creado satisfactoriamente.' }
         format.json { render :show, status: :created, location: @viatico }
       else
         format.html { render :new }
         format.json { render json: @viatico_detail.errors, status: :unprocessable_entity }
       end
     end
  end

  # PATCH/PUT /viatico_details/1
  # PATCH/PUT /viatico_details/1.json
  def update
    @gastos = Gasto.order(:codigo)
    @company = Company.find(1)
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @documents = @company.get_documents()
    @employees = @company.get_employees()
    @suppliers = @company.get_suppliers 
    @tipomov = Tipomov.all 
    @cajas = Caja.all      
    @destinos = Destino.all
    
    @viatico_detail = ViaticoDetail.find(params[:id]) 
    @viatico_detail.viatico_id  = @viatico.id 
    @viatico_detail.fecha = params[:viatico_detail][:fecha]
    
    
    
        
    respond_to do |format|
      if @viatico_detail.update_attributes(employee_id: 51 ,
        fecha: params[:viatico_detail][:fecha],
        importe: params[:viatico_detail][:importe],
        gasto_id: params[:viatico_detail][:gasto_id],
        destino_id: params[:viatico_detail][:destino_id],
        tm:params[:viatico_detail][:tm],
        numero: params[:viatico_detail][:numero],
        detalle: params[:viatico_detail][:detalle],
        document_id: params[:viatico_detail][:document_id],
        descrip: params[:viatico_detail][:descrip],
        supplier_id:  params[:viatico_detail][:supplier_id])
   begin
      @viatico[:inicial] = @viatico.get_total_inicial
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ingreso
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_egreso
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]
        @viatico.save
        
         if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        format.html { redirect_to @viatico, notice: 'Viatico detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @viatico }
      else
        format.html { render :edit }
        format.json { render json: @viatico.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /viatico_details/1
  # DELETE /viatico_details/1.json
  def destroy
      @cajas = Caja.all      
      if @viatico_detail.destroy
         begin
      @viatico[:inicial] = @viatico.get_total_inicial
    rescue
      @viatico[:inicial] = 0
    end 
    
    begin
      @viatico[:total_ing] = @viatico.get_total_ingreso
    rescue 
      @viatico[:total_ing] = 0
    end 
    begin 
      @viatico[:total_egreso]=  @viatico.get_total_egreso
    rescue 
      @viatico[:total_egreso]= 0 
    end 
    @viatico[:saldo] = @viatico[:inicial] +  @viatico[:total_ing] - @viatico[:total_egreso]
        @viatico.save
        
         if @viatico.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
        if @viatico.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viatico[:saldo]
          a.save
        end 
  
      flash[:notice]= "Item fue eliminado satisfactoriamente "
      redirect_to @viatico
    else
      flash[:error]= "Item ha tenido un error y no fue eliminado"
      render :show 
    end 
    
  end



  def update_purchase

    taxes = @viatico_detail[:importe] / 1.18

    payable_amount_now = @viatico_detail[:importe] - taxes 

puts "updateeeeeeee"
   
    begin
      puts  "whatever"
      puts  @viatico_detail[:fecha]
      puts  @viatico_detail[:fecha]


   a =   Purchase.new(         date1: @viatico_detail[:fecha], 
                                date2: @viatico_detail[:fecha2],  
                                payable_amount: payable_amount_now,
                                tax_amount: taxes, 
                                total_amount: @viatico_detail[:importe], 
                                charge: 0.00,
                                balance: 0.00, 
                                supplier_id: @viatico_detail[:supplier_id],  
                                user_id: current_user.id, 
                                company_id: 1, location_id: 1,
                                division_id: 1,
                                comments: ":Documento registrado de rendicion de Caja Chica",
                                processed: "1", return: "0", 
                                date_processed: Date.today, 
                                money: 2, 
                                payment_id: 1,
                                document_id: @viatico_detail[:document_id], 
                                moneda_id: 2, 
                                documento: @viatico_detail[:compro] , 
                                date3:@viatico_detail[:fecha2], 
                                pago: @viatico_detail[:importe], 
                                tipo: "0",
                                participacion: 0.00, 
                                tiponota: "1",
                                isc: 0.00, 
                                gasto_id: @viatico_detail[:gasto_id])

     
    a.save 

    rescue => err
        puts err.cause

        
    end




  end

  def update_purchase_RH 

    taxes = 0.00 

    payable_amount_now = @viatico_detail[:importe] - taxes 


    a =   Purchase.new(         date1: @viatico_detail[:fecha], 
                                date2: @viatico_detail[:fecha2],  
                                payable_amount: payable_amount_now,
                                tax_amount: taxes, 
                                total_amount: @viatico_detail[:importe], 
                                charge: 0.00,
                                balance: 0.00, 
                                supplier_id: @viatico_detail[:supplier_id],  
                                user_id: current_user.id, 
                                company_id: 1, location_id: 1,
                                division_id: 1,
                                comments: ":Documento registrado de rendicion de Caja Chica",
                                processed: "1", return: "0", 
                                date_processed: Date.today, 
                                money: 2, 
                                payment_id: 1,
                                document_id: nil, 
                                moneda_id: nil, 
                                documento: @viatico_detail[:document_id] , 
                                date3:@viatico_detail[:date2], 
                                pago: @viatico_detail[:importe], 
                                tipo: "0",
                                participacion: 0.00, 
                                tiponota: "1",
                                isc: 0.00, 
                                gasto_id: @viatico_detail[:gasto_id])

     
    a.save 

  end

    private

    # Use callbacks to share common setup or constraints between actions.
      def set_viatico 
      @viatico = Viatico.find(params[:viatico_id])
    end 
    
    def set_viatico_detail
      @viatico_detail = ViaticoDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def viatico_detail_params
      
      params.require(:viatico_detail).permit(:fecha,:fecha2, :descrip, :document_id, :numero, :importe, :detalle, :tm,
       :CurrTotal, :tranportorder_id,:date_processed,:ruc,:supplier_id,:gasto_id,:employee_id,:destino_id,
       :compro,:tipomov_id )
    end
end
