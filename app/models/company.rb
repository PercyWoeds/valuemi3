    class Company < ActiveRecord::Base
        
          $: << Dir.pwd + '/lib'
          
          require 'pry'
          require 'peru_sunat_ruc'
        
        
        validates_presence_of :user_id, :name
        
        belongs_to :user
    
        has_many :locations
        has_many :suppliers
        has_many :products
        has_many :products_kits
        has_many :restocks
        has_many :divisions
        has_many :customers
        has_many :invoices
        has_many :inventories
        has_many :company_users
        has_many :ajusts 
        
        
         def get_facturas_day_cliente(fecha1,fecha2,cliente)
         
          @facturas = Factura.where(["total <> 0  and  company_id = ? AND fecha >= ? and fecha<= ? and customer_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", cliente ]).order(:customer_id,:moneda_id,:fecha)
          return @facturas
          
       end 
       
    
       def get_cliente(id)
         @dato = Customer.find(id)
         return @dato 
       end 
       
       def get_qty_nota_credito(id,value )
        facturas  = FacturaDetail.where(factura_by: id)
         
         ret=0 
         
         if facturas
           
          for factura in facturas
              if(value == "imp1")
                ret -= factura.importe.to_f 
              elsif(value == "imp2")
                ret -= factura.implista
              else         
                ret -= factura.cantidad 
              end
              
          end 
        end 
         return ret 
       end 
       
       
       def get_documento_factura(id)
         
         @dato = Document.find(id)
         return @dato 
       end 
       
       def get_pendientes_cliente(fecha1,fecha2,cliente)
    
          @facturas = Factura.where([" balance > 0  and  company_id = ? AND fecha >= ? and fecha<= ? and customer_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", cliente ]).order(:customer_id,:moneda_id,:fecha)
          return @facturas
          
       end
    
      def get_facturas_day_value(fecha1,fecha2,value = "total",moneda)
          
          facturas = Factura.where([" company_id = ? AND fecha >= ? and fecha<= ? and moneda_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59",moneda])
          if facturas
          ret=0  
          for factura in facturas
            if factura.document_id == 2
              if(value == "subtotal")
                ret -= factura.subtotal
              elsif(value == "tax")
                ret -= factura.tax
              else         
                ret -= factura.total
              end
          else
              if(value == "subtotal")
                ret += factura.subtotal
              elsif(value == "tax")
                ret += factura.tax
              else         
                ret += factura.total
              end
          end
          end
          end 
    
          return ret
        
       end  
    
    def get_facturas_day_value_cliente(fecha1,fecha2,cliente,value = "total",moneda)
    
          facturas = Factura.where([" company_id = ? AND fecha >= ? and fecha<= ? and customer_id = ?
           and moneda_id  = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59",cliente,moneda ])
          if facturas
          ret=0  
          for factura in facturas
            if factura.document_id == 2
              if(value == "subtotal")
                ret -= factura.subtotal
              elsif(value == "tax")
                ret -= factura.tax
              else         
                ret -= factura.total
              end
            else  
              if(value == "subtotal")
                ret += factura.subtotal
              elsif(value == "tax")
                ret += factura.tax
              else         
                ret += factura.total
              end
            end 
          end
          end 
    
          return ret
        end 
       
    
    
        def to_hash
          hash=[]
    
          instance_variables_each{ |var| hash[var.to_s.delete('@')]= instance_variables_get(var)}
          hash
        end
        
        def actualiza_monthyear
    
          @factura = Factura.where(:year_mounth=> nil)
    
          for factura in @factura
              f = Factura.find(factura.id)
            if f
              @fechas =f.fecha2.to_s
              parts = @fechas.split("-")
              year = parts[0]
              mes  = parts[1]
              dia  = parts[2]      
              f.year_mounth = year+mes 
              f.save
            end 
          end 
        end 
        
        def actualiza_monthyear2
    
          @factura = Factura.where(:year_mounth=> nil)
    
          for factura in @factura
              f = Factura.find(factura.id)
            if f
              @fechas =f.fecha2.to_s
              parts = @fechas.split("-")
              year = parts[0]
              mes  = parts[1]
              dia  = parts[2]      
              f.year_mounth = year+mes 
              f.save
            end 
          end 
        end 
    
        def actualizar_purchase_monthyear
          @factura = Purchase.where(:yearmonth=> nil)
          for factura in @factura
              f = Purchase.find(factura.id)
            if f
              @fechas =f.date2.to_s
              parts = @fechas.split("-")
              year = parts[0]
              mes  = parts[1]
              dia  = parts[2]      
              f.yearmonth = year+mes 
              f.save
            end 
          end 
        end 
    
    
        def own(user)
          if(self.user_id == user.id)
            return true
          end
        end
        
        def can_view(user)
          if(self.own(user))
            return true
          else
            company_user = CompanyUser.where(company_id:  self.id, user_id:  user.id)
            
            if(company_user)
              return true
            end
          end
        end
        
        def get_banks()
           banks = Bank.all      
          return banks
        end
        
    
        def get_bank_acounts()
           bank_acounts = BankAcount.all      
          return bank_acounts
        end
        
        def get_marcas()
           marcas = Marca.all      
          return marcas
        end
        def get_modelos()
           modelos = Modelo.all      
          return modelos
        end
    
        def get_instruccions()
           instruccions = Instruccion.all      
          return instruccions
        end
    
        def get_documents()
           documents = Document.where(company_id: self.id).order(:descripshort)
             
          return documents
        end
    
        def get_documents2()
           documents = Document.where(company_id: self.id,).order(:descripshort)
             
          return documents
        end
    
        def get_monedas()
           monedas = Moneda.where(company_id: self.id).order(:description)
             
          return monedas
        end
    
        def get_transports()
           transports = Tranportorder.where(company_id: self.id).order(:code)
             
          return transports
        end
        
        
        def get_suppliers()
           suppliers = Supplier.where(company_id: self.id).order(:name)       
          return suppliers
        end
        
        def get_locations()
    
          locations = Location.where(company_id: self.id).order("name ASC")
          
          return locations
        end
        
        def get_divisions()
          divisions = Division.where(company_id:  self.id).order("name ASC")
          
          return divisions
        end
        def get_payments()
          payments = Payment.where(company_id:  self.id).order("descrip ASC")    
          
          return payments
        end
    
       
        
        def get_services()
           services = Service.where(company_id: self.id).order(:name)
           return services
        end
        def get_tipofacturas()
           tipos = Tipofactura.where(company_id: self.id).order(:descrip)
             
          return tipos
        end
        
    
        def get_addresses()
           addresses = Address.find_by_sql(['Select id,full_address as address from addresses' ]) 
           return addresses
        end
        
        def get_trucks()
           trucks = Truck.all.order('placa') 
           return trucks
        end
        
        def get_employees()
           employees =  Employee.where(:active => "1").order(:full_name)
           return employees
        end
            
        def get_empsubs()
           empsubs = Subcontrat.all 
           return empsubs
        end 
    
        def get_unidads()
           unidads = Unidad.all.order(:id)
           return unidads
        
        end 
        
        def get_tarjetas()
           tarjetas = Tarjetum.all.order(:id)
           return tarjetas
        end 
        
        
        def get_puntos()
          puntos = Punto.all 
          return puntos
        end
    
        def get_servicebuys()
           servicebuys = Servicebuy.all.order(:id)
           return servicebuys
        end 
    
        def get_categories()
           category = ProductsCategory.all.order(:category)
           return category
        end 
    
        def get_categoria_name(id)
           category = ProductsCategory.find(id)
           return category.category
        end 
        
        def get_empleado_name(id)
           empleado = Employee.find(id)
           return empleado.full_name 
        end 
        
        def get_service_name(id)
           category = Servicebuy.find(id)
           return category.name 
        end 
         def get_tipocambio(fecha1)
           tipocambio = Tipocambio.find(fecha1.to_date)
           return tipocambio.venta 
        end 
        def get_last_tax_name(tax_number)
          product = Product.where(company_id: self.id)
          
          if(product.any?)
            if(tax_number == 1)
              return product[0].tax1_name
            elsif(tax_number == 2)
              return product[0].tax2_name
            else
              return product[0].tax3_name
            end
          end
        end
        
        def get_last_tax(tax_number)
          product = Product.where(company_id: self.id)
    
          if(product.any?)
            if(tax_number == 1)
              return product[0].tax1
            elsif(tax_number == 2)
              return product[0].tax2
            else
              return product[0].tax3
            end
          end
        end
        
        def delete_logo()
          begin
            deleteFile("public#{self.logo}")
          rescue
            # nothing
          end
          
          begin
            deleteFile(img_name_size("public#{self.logo}", 200))
          rescue
            # nothing
          end
          
          begin
            deleteFile(img_name_size("public#{self.logo}", 100))
          rescue
            # nothing
          end
        end
        
        def upload_logo(file)
          require 'digest/md5'
          
          # Delete previous logo
          if(self.logo != "")
            self.delete_logo()
          end
          
          dir = "public/uploads/companies/#{self.user_id}/"
          makedir(dir)
      	
        	name = file.original_filename
      	
        	new_name = Digest::MD5.hexdigest(Time.now.to_s)
        	ext = getFileExt(name)
      	
        	new_name = "#{new_name}_300.#{ext}"
      	
        	path = File.join(dir, new_name)
      	
        	File.open(path, "wb") { |f| 
        		f.write(file.read)
        	}
      	
        	# Quitamos parte de public para el path
        	path_arr = path.split('/')
        	path_arr.delete_at(0)
        	path = '/' + path_arr.join('/')
          
          resizeImage(path, 300)
          
          copy_file("public#{path}", img_name_size("public#{path}", 200))
          resizeImage(img_name_size(path, 200), 200)
          
          copy_file("public#{path}", img_name_size("public#{path}", 100))
          resizeImage(img_name_size(path, 100), 100)
          
          self.logo = path
          self.save
          
          return path
        end
        
        # Get subtotal made from invoices in a date
        def get_invoices_value_date(date, value)
          date_arr = date.split("-")
          year = date_arr[0]
          month = date_arr[1]
          
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND date_processed >= ? AND date_processed <= ? AND processed = '1'", self.id, "#{date} 00:00:00", "#{year}-#{month}-31 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        # Get subtotal made from invoices in an exact date
        def get_invoices_value_exact_date(date, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND date_processed >= ? AND date_processed <= ? AND processed = '1'", self.id, "#{date} 00:00:00", "#{date} 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
    
        # Get subtotal made from invoices in a date
        def get_invoices_value_date(date, value)
          date_arr = date.split("-")
          year = date_arr[0]
          month = date_arr[1]
          
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND date_processed >= ? AND date_processed <= ? AND processed = '1'", self.id, "#{date} 00:00:00", "#{year}-#{month}-31 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        
        def get_users()
          owner = self.user
          users = []
          users.push(owner)
          
          #company_users = CompanyUser.where(:company_id => self.id)
          
          users1 = CompanyUser.find_by(company_id:  self.id)
    
          @user_id =users1.user_id
          users =User.where(:id => @user_id)
    
          users = users.map {|s| [s.username, s.id]}
          users_f = [["", nil]]
          users_f += users
          users = users_f    
    
          return users
        end
    
       def get_guias_year(year)
          @delivery = Delivery.where(["fecha1>= ? AND fecha1 <= ? and company_id  = ? ", "#{year}-01-01 00:00:00", "#{year}-12-31 23:59:59", self.id])   
          return @delivery
       end
       
    
       def get_guias_year_month(year,month)
          @delivery = Delivery.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{year}-#{month}-01 00:00:00", "#{year}-#{month}-31 23:59:59"])
          return @delivery
       end 
       #orden de transporte
       def get_ordertransporte_day(fecha1,fecha2,tipo)
         
          if tipo == "0"
            @orden = Tranportorder.where(["company_id = ? AND created_at >= ? AND created_at <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
          else
            @orden = Tranportorder.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
          end 
          return @orden 
       end 
       
       
       def get_guias_day(fecha1,fecha2)
          @delivery = Delivery.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
          return @delivery
       end 
       def get_guias_day1(fecha1,fecha2)
          @delivery = Delivery.where(["company_id = ? AND created_at >= ? AND created_at <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
          return @delivery
       end 
       def get_guias_day2(fecha1,fecha2)
          @delivery = Delivery.where(["company_id = ? AND fecha3 >= ? AND fecha3 <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
          return @delivery
       end 
       def get_guias_day3(fecha1,fecha2)
          @delivery = Delivery.where(["company_id = ? AND fecha4 >= ? AND fecha4 <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
          return @delivery
       end 
    
    
      def get_guias_2(fecha1,fecha2)
          @delivery = Delivery.where(["processed<> '4' and  processed <> '2' and company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
          return @delivery
       end 
    
       def get_guias_3(fecha1,fecha2)
          @delivery = Delivery.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ? ", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"])
          return @delivery
       end 
    
       def get_guias_4(fecha1,fecha2)
          @delivery = Delivery.where(["company_id = ? AND created_at >= ? AND created_at <= ? ", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order('created_at')
          return @delivery
       end 
    
       def get_services_year_month(year,month)
          @serviceorder = Serviceorder.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{year}-#{month}-01 00:00:00", "#{year}-#{month}-31 23:59:59"])
          return @serviceorder
       end 
       def get_services_day(fecha1,fecha2)
          @serviceorder = Serviceorder.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"])
          return @serviceorder
       end 
    
      ## generar archivo txt
       def get_facturas_year_month_day(fecha1)
          @facturas = Factura.where(["company_id = ? AND fecha >= ? and fecha<= ?", self.id, "#{fecha1} 00:00:00","#{fecha1} 23:59:59"])
          return @facturas    
       end 
    
       ## generar archivo concar
       def get_facturas_year_month_day2(fecha1,fecha2)
          @facturas = Factura.where(["company_id = ? AND fecha >= ? and fecha<= ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"])
          return @facturas    
       end 
    
    
      ## ESTADO DE CUENTA 
      
      def get_facturas_day(fecha1,fecha2,moneda)
         
        a =  Sellvale.where(["fecha >= ? and fecha<= ? and td <> ? and importe2 IS NOT NULL ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59","N" ]).order(:fecha)
        
        for dato in a 
          
          dato.importe2 = dato.importe.to_f 
          dato.update_attributes(:importe2=> dato.importe.to_f)
        end 
         
         lcCode=""
         lcCode1=""
         @boletas = Sellvale.select("fecha,td,serie,ruc,MIN(numero) as minimo, MAX(numero) as maximo,sum(importe2) as total").where(["fecha >= ? and fecha<= ? and td= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59","B" ]).group(:fecha,:td,:serie,:ruc)
        # @boletas = Sellvale.select("fecha,td,cod_prod,ruc,MIN(numero) as minimo, MAX(numero) as maximo,sum(importe2) as total").where(["fecha >= ? and fecha<= ? and td<> ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59","N" ]).group(:fecha,:td,:serie,:numero,:cod_prod,:ruc)
          TmpFactura.delete_all
          
          for boleta in @boletas  
          
                lcCode = boleta.minimo 
                lcCode1= boleta.maximo 
                lcSerie = boleta.serie 
                
                if boleta.total != nil 
                  lcVventa0 = boleta.total / 1.18
                  
                  lcVventa  = lcVventa0.round(2)
                  lcTax0    = boleta.total  - lcVventa
                  lcTax     = lcTax0
                  lcTotal0  = boleta.total
                  lcTotal   = lcTotal0.round(2)  
                  lcFecha   = boleta.fecha
                  lcTd      = boleta.td 
                  
                  
                  if boleta.ruc.strip  != nil  or boleta.ruc !="00000000000"
                    
                    lcRucCliente = boleta.ruc 
                    ruc_number =  boleta.ruc 
                    #  lcRazonCliente  = PeruSunatRuc.name_from ruc_number
                   lcRazonCliente = ""
                  else
                    lcRucCliente = "0"
                    lcRazonCliente = "CLIENTE GENERICO "
                  end 
                  
                a= TmpFactura.new(document_id: 17 ,subtotal: lcVventa , tax: lcTax , total: lcTotal, fecha: lcFecha, serie: lcSerie, numero: lcCode,numero2:lcCode1,td: lcTd,ruc: lcRucCliente,name:lcRazonCliente, moneda_id:2,tipo2:"0",tipo10:"12" )
                a.save 
              end 
            lcCode=""
          end
          
         @boletas = Sellvale.select("fecha,td,serie,numero,ruc,MIN(numero) as minimo, MAX(numero) as maximo,sum(importe2) as total").where(["fecha >= ? and fecha<= ? and td= ?  ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59","F" ]).group(:fecha,:td,:serie,:numero,:ruc)
        # @boletas = Sellvale.select("fecha,td,cod_prod,ruc,MIN(numero) as minimo, MAX(numero) as maximo,sum(importe2) as total").where(["fecha >= ? and fecha<= ? and td<> ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59","N" ]).group(:fecha,:td,:serie,:numero,:cod_prod,:ruc)
         
          
          for boleta in @boletas  
          
                lcCode = boleta.minimo
                lcSerie = boleta.serie 
                
                if boleta.total != nil 
                  lcVventa0 = boleta.total / 1.18
                  
                  lcVventa  = lcVventa0.round(2)
                  lcTax0    = boleta.total  - lcVventa
                  lcTax     = lcTax0
                  lcTotal0  = boleta.total
                  lcTotal   = lcTotal0.round(2)  
                  lcFecha   = boleta.fecha
                  lcTd      = boleta.td 
                  
                  
                  if boleta.ruc.strip  != nil  or boleta.ruc !="00000000000"
                    
                    lcRucCliente = boleta.ruc 
                    ruc_number =  boleta.ruc 
                    #  lcRazonCliente  = PeruSunatRuc.name_from ruc_number
                   lcRazonCliente = ""
                  else
                    lcRucCliente = "0"
                    lcRazonCliente = "CLIENTE GENERICO "
                  end 
                  
                a= TmpFactura.new(document_id: 16 ,subtotal: lcVventa , tax: lcTax , total: lcTotal, fecha: lcFecha, serie: lcSerie, numero: lcCode,td: lcTd,ruc: lcRucCliente,name:lcRazonCliente, moneda_id:2,tipo2:"0",tipo10:"12")
                a.save 
              end 
            lcCode=""
          end
          
          
          @facturas = Factura.where([" company_id = ? AND fecha >= ? and fecha<= ? and moneda_id = ? and substring(code,1,4)<> ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59",moneda,"BB02" ]).order(:fecha)    
            for boleta in @facturas
          
                lcCodigo = boleta.code.split("-") 
    
                lcCode  = lcCodigo[1] 
                lcSerie = lcCodigo[0] 
                
                if boleta.total != nil 
                  
                  
                  lcVventa0 = boleta.total / 1.18
                  lcVventa =lcVventa0.round(2)
                  lcTax0   =  boleta.total  - lcVventa
                  lcTax    = lcTax0
                  lcTotal0 = boleta.total
                  lcTotal  = lcTotal0.round(2)  
                  lcFecha = boleta.fecha
                  lcTd = boleta.document.descripshort
                  
                  lcRucCliente = boleta.customer.ruc 
                  lcRazonCliente = boleta.customer.name 
                  
                  
                  
                  if boleta.document_id == 2
                      lcDocumentoId  = boleta.document_id
                     lcTipo2 = "6"
                     lcVventa = lcVventa * -1
                     lcTax = lcTax * -1
                     lcTotal = lcTotal * -1
                  
                  else
                     lcDocumentoId  = boleta.document_id
                     lcTipo2 = "0"
                  
                  end 
                  
                a= TmpFactura.new(document_id: lcDocumentoId ,subtotal: lcVventa , tax: lcTax , total: lcTotal, fecha: lcFecha, serie: lcSerie, numero: lcCode,td: lcTd,ruc: lcRucCliente,name:lcRazonCliente, moneda_id:2,tipo2: lcTipo2)
                a.save 
              end 
            lcCode=""
          end
        
          
          
          
          @tmpfacturas=TmpFactura.all.order(:fecha,:td,:serie,:numero)
          return @tmpfacturas 
          
       end 
       
      
      def get_facturas_day3(fecha1,fecha2,moneda)
        
        
        @facturas = Factura.find_by_sql(['Select facturas.*,factura_details.quantity,
          factura_details.price,factura_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from factura_details   
          INNER JOIN facturas ON factura_details.factura_id = facturas.id
          INNER JOIN products ON factura_details.product_id = products.id
          WHERE facturas.fecha >= ? and facturas.fecha <= ?  and moneda_id = ? and substring(facturas.code,1,4)<> ? and products.products_category_id != ?
          order by facturas.fecha', "#{fecha1} 00:00:00","#{fecha2} 23:59:59",moneda,"BB02","1" ])
        
          return @facturas 
          
       end 
      
      
      
    
      ## REPORTES DE LIQUIDACION  DE COBRANZA
    
       def get_customer_payments(fecha1,fecha2)
          @facturas =   CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
          customer_payments.code  as code_liq,facturas.code,facturas.customer_id,facturas.fecha,
          facturas.moneda_id,customer_payments.bank_acount_id,
          customer_payment_details.factory,
          customer_payments.fecha1
          from customer_payment_details   
          INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
          INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id  
          WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? order by customer_payments.code', "#{fecha1} 00:00:00",
          "#{fecha2} 23:59:59" ])  
          
          return @facturas   
          
       end
       
       def get_customer_payments_2(fecha1,fecha2)
          @facturas =   CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
        customer_payments.code  as code_liq,facturas.code,facturas.customer_id,facturas.fecha,
        facturas.moneda_id,customer_payments.bank_acount_id,
        customer_payment_details.factory,
        customer_payments.fecha1
        from customer_payment_details   
        INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
        INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id  
        WHERE facturas.tipoventa_id <> ? and customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? and customer_payments.document_id <> 14 order by customer_payments.code',"2", "#{fecha1} 00:00:00",
        "#{fecha2} 23:59:59" ])  
            
          return @facturas   
          
       end
       def get_customer_payments_3(fecha1,fecha2)
          @facturas =   CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
        customer_payments.code  as code_liq,facturas.code,facturas.customer_id,facturas.fecha,
        facturas.moneda_id,customer_payments.bank_acount_id,
        customer_payment_details.factory,
        customer_payments.fecha1
        from customer_payment_details   
        INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
        INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id  
        WHERE facturas.tipoventa_id = ? and customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? and customer_payments.document_id <> 14 order by customer_payments.code',"2", "#{fecha1} 00:00:00",
        "#{fecha2} 23:59:59" ])  
            
          return @facturas   
          
       end
       
       def get_customer_payments_client_banco(fecha1,fecha2,customer,banco )
          @facturas =   CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
      customer_payments.code  as code_liq,facturas.code,facturas.customer_id,facturas.fecha,
      facturas.moneda_id,customer_payments.bank_acount_id,facturas.document_id ,
      customer_payment_details.factory,
      customer_payments.fecha1
      from customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id  
      WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? and facturas.customer_id = ? and customer_payments.bank_acount_id = ? order by customer_payments.code', "#{fecha1} 00:00:00",
      "#{fecha2} 23:59:59",customer,banco ])  
          
          return @facturas   
          
       end
       
       
       
    
      #total ingresos x banco 
    
       def get_customer_payments_value(fecha1,fecha2,id)
    
          facturas = CustomerPayment.where([" company_id = ? AND fecha1 >= ? and fecha1 <= ? and bank_acount_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" , id]).order(:id)
          ret = 0 
          if facturas 
          ret=0  
            for factura in facturas      
                ret += factura.total
            end
          end 
          return ret    
       end 
    
    
      #total ingreos x banco abierto por cliente 
      def get_customer_payments_value_customer2(fecha1,fecha2,id)
      facturas = CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
      facturas.code,facturas.customer_id,facturas.fecha,customer_payment_details.factory,customer_payments.bank_acount_id from customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id    
      WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ?  and 
      customer_payments.bank_acount_id = ?',
       "#{fecha1} 00:00:00","#{fecha2} 23:59:59",id ])
          ret = 0     
    
          return facturas 
       end
    
      #total ingreos x banco abierto por  factura 
      def get_customer_payments_value_customer3(code)
    
      facturas = CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
      facturas.code as nrofactura,facturas.customer_id,facturas.fecha,customer_payment_details.factory,
      customer_payments.bank_acount_id,customer_payments.code  
      FROM  customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id    
      WHERE facturas.code = ?',code ])
    
          return facturas 
       end 
    
    
       #total banco x cliente
      def get_customer_payments_value_customer(fecha1,fecha2,id,cliente,value)
      facturas = CustomerPayment.find_by_sql(['Select DISTINCT ON (1)  customer_payments.id,customer_payments.total,
      facturas.code,facturas.customer_id,facturas.fecha,customer_payment_details.factory from customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id    
      WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ?  and 
      customer_payments.bank_acount_id = ?  and facturas.customer_id = ?',
       "#{fecha1} 00:00:00","#{fecha2} 23:59:59",id,cliente ])
          ret = 0     
    
          if facturas 
          ret=0  
            for d in facturas                    
                  if (value == "total")
                    ret += d.total    
                  
                  end
            end       
          end     
          return ret    
       end 
      def get_customer_payments_cabecera(fecha1,fecha2)
        
            @payments = CustomerPayment.where(["company_id= ? and fecha1 >= ? and fecha1 <=? ",self.id, "#{fecha1} 00:00:00" ,"#{fecha2} 23:59:59"]).order(:bank_acount_id,:fecha1)
            return @payments 
      end 
      def get_customer_payments_cabecera2(fecha1,fecha2,banco)
        
            @payments = CustomerPayment.where(["company_id = ? and fecha1 >= ? and fecha1 <=? and bank_acount_id = ?  ",self.id, "#{fecha1} 00:00:00" ,"#{fecha2} 23:59:59",banco]).order(:bank_acount_id,:fecha1)
            return @payments 
      end 
    
      def get_customer_payments_banco(fecha1,fecha2,banco)
        
            @payment1 = CustomerPayment.where(["company_id= ? and fecha1 >= ? and fecha1 <=? and bank_acount_id = ?",self.id, "#{fecha1} 00:00:00" ,"#{fecha2} 23:59:59",banco]).order(:fecha1)
            @payment2 = Deposito.where(["company_id= ? and fecha1 >= ? and fecha1 <=? and bank_acount_id = ?",self.id, "#{fecha1} 00:00:00" ,"#{fecha2} 23:59:59",banco]).order(:fecha1)
            
            @payments = (@payment1+@payment2)
            
            return @payments 
      end 
    
    
      def get_customer_payments_value_otros_customer(fecha1,fecha2,value,cliente,moneda_pago)
    
        facturas = CustomerPayment.find_by_sql(['Select  DISTINCT ON (1)  customer_payments.id,
        customer_payment_details.total,facturas.code,facturas.customer_id,
        facturas.fecha,customer_payment_details.factory, 
        customer_payments.bank_acount_id
        from customer_payment_details   
        INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
        INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id    
        WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? and facturas.customer_id = ?', "#{fecha1} 00:00:00",
      "#{fecha2} 23:59:59",cliente ])
    
          ret = 0 
          ret1=0  
          ret2=0  
          
    
          if facturas 
            for factura in facturas  
            
                @banco = BankAcount.find(factura.bank_acount_id)
                moneda = @banco.moneda_id
                
                @detail = CustomerPaymentDetail.where(:customer_payment_id => factura.id)
    
                for d in @detail 
                
                  if(value == "ajuste")
                    if moneda == 2 
                      ret2 += d.ajuste
                    else
                      ret1 += d.ajuste
                    end 
                  elsif (value == "compen")
                    if moneda == 2 
                      ret2 += d.compen 
                    else 
                      ret1 += d.compen 
                    end 
                  elsif (value == "total")
                    if moneda == 2
                      ret2 += d.compen   
                    else
                      ret1 += d.compen   
                    end
                  else         
                    if moneda == 2
                      ret2 += d.factory
                    else
                      ret1 += d.factory
                    end
                  end
                end 
    
            end
          end 
          puts moneda_pago 
          if moneda_pago == 2
            return ret2    
          else
            return ret1
          end 
       end 
       
       def get_customer_payments_value_otros_customer2(fecha1,fecha2,value,moneda_pago)
    
        facturas = CustomerPayment.find_by_sql(['Select  DISTINCT ON (1)  customer_payments.id,
        customer_payment_details.total,facturas.code,facturas.customer_id,
        facturas.fecha,customer_payment_details.factory, 
        customer_payments.bank_acount_id
        from customer_payment_details   
        INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
        INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id    
        WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? ', "#{fecha1} 00:00:00",
      "#{fecha2} 23:59:59" ])
    
          ret = 0 
          ret1=0  
          ret2=0  
          
    
          if facturas 
            for factura in facturas  
            
                @banco = BankAcount.find(factura.bank_acount_id)
                moneda = @banco.moneda_id
                
                @detail = CustomerPaymentDetail.where(:customer_payment_id => factura.id)
    
                for d in @detail 
                
                  if(value == "ajuste")
                    if moneda == 2 
                      ret2 += d.ajuste*-1
                    else
                      ret1 += d.ajuste*-1
                    end 
                  elsif (value == "compen")
                    if moneda == 2 
                      ret2 += d.compen 
                    else 
                      ret1 += d.compen 
                    end 
                  elsif (value == "total")
                    if moneda == 2
                      ret2 += d.compen   
                    else
                      ret1 += d.compen   
                    end
                  else         
                    if moneda == 2
                      ret2 += d.factory
                    else
                      ret1 += d.factory
                    end
                  end
                end 
    
            end
          end 
          puts moneda_pago 
          if moneda_pago == 1
            return ret2    
          else
            return ret1
          end 
       end 
       
       def get_customer_payments_cliente(fecha1,fecha2,cliente)
    
      @facturas =CustomerPayment.find_by_sql(['Select customer_payments.id,customer_payment_details.total,
      customer_payments.code  as code_liq,facturas.code,facturas.customer_id,facturas.fecha,
      facturas.moneda_id,customer_payments.bank_acount_id,
      customer_payment_details.factory,
      customer_payments.fecha1
      from customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      INNER JOIN customer_payments ON customer_payments.id = customer_payment_details.customer_payment_id    
      WHERE customer_payments.fecha1 >= ? and customer_payments.fecha1 <= ? and facturas.customer_id = ?', "#{fecha1} 00:00:00",
      "#{fecha2} 23:59:59",cliente ])
          
          return @facturas
          
       end 
    
    
    
       def get_customer_payments_value_otros(fecha1,fecha2,value='factory')
    
          facturas = CustomerPayment.where(["fecha1 >= ? and fecha1 <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])        
              ret=0  
              for factura in facturas
    
                @detail = CustomerPaymentDetail.where(:customer_payment_id => factura.id)
    
                for d in @detail 
                  if(value == "ajuste")
                    ret += d.ajuste
                  elsif (value == "compen")
                    ret += d.compen 
                  else         
                    ret += d.factory
                  end
                end 
    
              end    
    
          return ret
       end 
    
    
      ## REPORTE DE ESTADISTICAS DE PAGOS pivot
    
      def get_customer_payments2(moneda,fecha1,fecha2)
         
          
         @facturas = Factura.find_by_sql(["
         SELECT   year_mounth as year_month,
         customer_id,
         SUM(balance) as balance   
         FROM facturas
         WHERE moneda_id = ? and balance>0 and fecha >= ? and fecha  <= ? and document_id <> 2 
         GROUP BY 2,1
         ORDER BY 2,1 ", moneda,"#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])    
         
         
         @facturas2 = Factura.find_by_sql(["
         SELECT   year_mounth as year_month,
         customer_id,
         SUM(balance) as balance   
         FROM facturas
         WHERE moneda_id = ? and balance>0 and fecha >= ? and fecha  <= ? and document_id = 2 
         GROUP BY 2,1
         ORDER BY 2,1 ", moneda,"#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])    
         
         Tempfactura.delete_all
         
        
          for f in @facturas
             if f.customer_id != nil
              b = Tempfactura.new(year_month: f.year_month , customer_id: f.customer_id,balance: f.balance)
              b.save 
            end 
          end 
         
         for c in @facturas2
         
               lcBalance= 0 
               
               tf = Tempfactura.find_by(year_month: c.year_month, customer_id: c.customer_id)
             
             if tf 
                 tf.balance -= c.balance 
                 tf.save 
             else
               lcbalance = c.balance * -1
               puts "cliente "
               puts c.customerid 
               a= Tempfactura.new(:year_month=> c.year_month,:customer_id => c.customer_id,:balance=>lcBalance)
               a.save 
             end
             
         end 
         
         @facturas = Tempfactura.order(:customer_id,:year_month) 
         
        if @facturas.last != nil  
          return @facturas
        else
          return nil 
        end 
       end 
       
       def get_customer_payments20(moneda,fecha1,fecha2)
         
          
         @facturas = CustomerPaymentDetail.find_by_sql(["
         SELECT   month_year as year_month,
         customer_id,
         SUM(balance) as balance   
         FROM tempcps
         WHERE moneda_id = ? and balance>0 and fecha2 >= ? and fecha2  <= ?  
         GROUP BY 2,1
         ORDER BY 2,1 ", moneda,"#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])    
         
         
         Tempfactura.delete_all
         
          for f in @facturas
             if f.customer_id != nil
              b = Tempfactura.new(year_month: f.year_month , customer_id: f.customer_id,balance: f.balance)
              b.save 
            end 
          end 
         
         @facturas = Tempfactura.order(:customer_id,:year_month) 
         
        return @facturas
          
       end 
    
       def get_customer_payments_value2(fecha1,fecha2)
    
       #   facturas = Factura.find_by_sql("Select customer_id,month(fecha2) as mes,year(fecha2) as anio from facturas group by month(fecha2),year(fecha2)")
          ret = 0 
          if facturas 
          ret=0  
            for factura in facturas      
    
                ret += factura.total
    
            end
          end 
          return ret    
       end 
    
    
    
      def get_customer_payments_detail_value(fecha1,fecha2,value="total")
    
          facturas = CustomerPaymentDetail.where([" fecha1 >= ? and fecha1 <= ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"]).order(:id)
          ret=0  
          
          if facturas
          
          
          for factura in facturas      
            if(value == "subtotal")
              ret += factura.subtotal
            elsif(value == "factory")
              ret += factura.factory.round(2)
            else         
              ret += factura.total.round(2)
            end
          end
          
          end 
          return ret
         
          
       end 
    
       def actualizar_fecha2
    
          facturas = Factura.where(:fecha2 => nil )
          for factura in facturas
              fact =  Factura.find(factura.id)
            if fact.payment 
              days = fact.payment.day 
    
              fechas2 = factura.fecha + days.days           
            else
              fechas2 = factura.fecha 
            end 
              fact.update_attributes(:fecha2=>fechas2)   
          end 
    
       end
       
       def actualizar_fecha20(fecha1,fecha2)
          Tempcp.delete_all 
          facturas = CustomerPayment.where([" fecha1 >= ? and fecha1 <= ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"])
          
          for customerpayment  in facturas
              moneda = customerpayment.bank_acount.moneda_id
              fact =  CustomerPaymentDetail.where(customer_payment_id: customerpayment.id)
              
              for detalle in fact 
                if detalle.factura 
                cliente = detalle.factura.customer_id
                fechas2 = customerpayment.fecha1 
                @fechas = customerpayment.fecha1.to_s
                
                parts = @fechas.split("-")
                year = parts[0]
                mes  = parts[1]
                dia  = parts[2]      
                yearmes = year+mes 
                #balance_0 =  fact.total - fact.factory + fact.ajuste - fact.compen  
                balance_0 =  detalle.total 
                b= Tempcp.new(:fecha2=>fechas2,:month_year=> yearmes,:customer_id=> cliente,:balance=> balance_0,:moneda_id=> moneda,:customer_payment_detail_id=> detalle.id)            
                b.save
                
              end
              end 
              
              
          end 
    
       end
       
       
        def actualizar_purchase_fecha2
    
          facturas = Factura.where(:fecha2 => nil )
          for factura in facturas
              fact =  Factura.find(factura.id)
              days = fact.payment.day 
              fechas2 = factura.fecha + days.days           
              fact.update_attributes(:fecha2=>fechas2)   
          end 
    
       end
       def actualizar_detraccion
          
          det = 0
    
          Factura.update_all(:detraccion=>0)
    
          pagonacion = CustomerPayment.where(:bank_acount_id => 6 )
    
    
          for f in pagonacion 
          
              fact =  f.get_payment_dato(f.id)
          
              for f2 in fact  
                  det =  f2.total 
                  
                  begin 
                  a  =  Factura.find(f2.factura_id)            
                  a.detraccion = det            
                  a.save 
              
                  end 
              end       
    
          end 
    
       end
    
    
      def get_supplier_payments2(moneda,fecha1,fecha2)
    
         @facturas = Purchase.find_by_sql(["
        SELECT   yearmonth as year_month,
         supplier_id,
         SUM(balance) as balance   
         FROM purchases 
         WHERE moneda_id = ? and balance>0 and date1 >= ? and date1  <= ?
         GROUP BY 2,1
         ORDER BY 2,1 ", moneda,fecha1,fecha2 ])    
    
        return @facturas
          
       end 
    
    
      #reporte de cancelaciones detallado x proveedor
    
      def get_supplier_payments0(fecha1,fecha2)
          @vouchers = SupplierPayment.where([" company_id = ? AND fecha1 >= ? and fecha1<= ?  ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ]).order(:id)
          return @vouchers    
      end 
        
      def get_paymentsD_day_value(fecha1,fecha2,value = "total")
    
          facturas = SupplierPayment.where(["company_id = ? AND fecha1 >= ? and fecha1<= ?  ", 
            self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
          ret = 0
            for factura in facturas      
                      
                @detail = SupplierPaymentDetail.where(:supplier_payment_id => factura.id)
    
                for d in @detail 
                  if(value == "ajuste")
                    ret += d.ajuste
                  elsif (value == "compen")
                    ret += d.compen 
                  else
                    ret += d.total            
                  end
                end 
    
            end
    
            return ret
       end 
    
       def get_paymentsC_day_value(fecha1,fecha2,value = "total")
          ret = 0
          facturas = SupplierPayment.where(["company_id = ? AND fecha1 >= ? and fecha1<= ? ",
           self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
    
            for d in facturas                
                  if(value == "ajuste")
                    ret += d.ajuste
                  elsif (value == "compen")
                    ret += d.compen 
                  else
                    ret += d.total            
                  end          
            end
    
            return ret
       end 
    
    
      def get_payments_detail_value(fecha1,fecha2,value = "total",moneda)
    
          facturas = SupplierPayment.where(["company_id = ? AND fecha >= ? and fecha<= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda ]).order(:customer_id,:moneda_id)
          ret=0  
          if facturas
          
            for factura in facturas      
              if(value == "subtotal")
                ret += factura.subtotal
              elsif(value == "tax")
                ret += factura.tax
              else         
                ret += factura.total.round(2)
              end
            end
           
          end 
          
          return ret    
       end 
    
    
    
       ## Pendientes 
    
       def get_pendientes_day(fecha1,fecha2)
    
          @facturas = Factura.where([" balance > 0  and  company_id = ? AND fecha >= ? and fecha<= ? and tipoventa_id <> '1' ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"]).order(:customer_id,:moneda_id,:fecha)
          return @facturas
          
       end 
    
       
    
       
       def get_pendientes_day_value(fecha1,fecha2,value = "balance",moneda)
    
          facturas = Factura.where(["balance>0  and  company_id = ? AND fecha >= ? and fecha<= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda ]).order(:customer_id,:moneda_id)
          if facturas
          ret=0  
          for factura in facturas
           if factura.document_id != 2
            if(value == "subtotal")
                ret += factura.subtotal
              elsif(value == "tax")
                ret += factura.tax
              else         
                ret += factura.balance.round(2)
              end
            else
              if(value == "subtotal")
                ret -= factura.subtotal
              elsif(value == "tax")
                ret -= factura.tax
              else         
                ret -= factura.balance.round(2)
              end
           end
          end
         end 
    
          return ret    
       end 
    
    
       def get_pendientes_day_cliente_value(fecha1,fecha2,value = "total",cliente,moneda)
        ret = 0
          facturas = Factura.where(["balance>0  and  company_id = ? AND fecha >= ? and fecha<= ? and moneda_id = ? and customer_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , cliente ]).order(:customer_id,:moneda_id)
          if facturas
    
          for factura in facturas
          
            if factura.document_id != 2
              if(value == "subtotal")
                ret += factura.subtotal
              elsif(value == "tax")
                ret += factura.tax
              else         
                ret += factura.balance.round(2)
              end
            else
              if(value == "subtotal")
                ret -= factura.subtotal
              elsif(value == "tax")
                ret -= factura.tax
              else         
                ret -= factura.balance.round(2)
              end
            end
          end
          
          end 
    
          return ret
          
       end 
       
       def get_pendientes_day_customer(fecha1,fecha2,value,moneda)
    
          facturas = Factura.where(["balance>0  and  company_id = ? AND fecha >= ? and fecha<= ? AND customer_id = ? and moneda_id =  ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", value , moneda ]).order(:customer_id,:moneda_id)
          ret=0  
    
          if facturas
          
          
          
          for factura in facturas
          
            if factura.document_id != 2
              if(value == "subtotal")
                ret += factura.subtotal
              elsif(value == "tax")
                ret += factura.tax
              else         
                ret += factura.balance.round(2)
              end
              
            else
              if(value == "subtotal")
                ret -= factura.subtotal
              elsif(value == "tax")
                ret -= factura.tax
              else         
                ret -= factura.balance.round(2)
              end
            end
          end
          end 
    
          return ret    
       end 
       
      def get_pendientes_day_customer_detraccion(fecha1,fecha2,cliente)
    
          facturas = Factura.where(["balance>0  and  company_id = ? AND fecha >= ? and fecha<= ? AND customer_id = ?  ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", cliente ]).order(:customer_id,:moneda_id)
    
          if facturas
          ret=0  
          
          
            for factura in facturas
          
              if factura.detraccion != nil
                ret += factura.detraccion.round(2)
              end 
            end
          end 
    
          return ret    
       end 
       
       def get_services_day2( fecha1,fecha2, value = "total")
        
          services = Serviceorder.where([" company_id = ?  AND fecha1 >= ? AND fecha1 <= ?", self.id,"#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order("id desc")
          ret = 0
          
          for service in services
            puts service.code 
    
            if(value == "subtotal")
              ret += service.subtotal
            elsif(value == "tax")
              ret += service.tax
            elsif(value == "detraccion")
            ret += service.detraccion
            else 
              
              ret += service.total
            end
          end
          
          return ret
        end
       # Return value 
       def get_viaticos0(fecha1,fecha2,cajaid)
         viaticos = Viatico.where([" company_id = ?  AND fecha1 >= ? AND fecha1 <= ? and caja_id = ?", self.id,"#{fecha1} 00:00:00", "#{fecha2} 23:59:59",cajaid]).order(:code)
         return viaticos 
       end 
    
       
       def get_viaticos
         viaticos = Viatico.where([" company_id = ?  AND fecha1 >= ? AND fecha1 <= ?", self.id,"#{year}-#{month}-01 00:00:00", "#{year}-#{month}-31 23:59:59"]).order(:code)
         return viaticos 
       end 
    
       # Return value for user
       def get_services_year_month_value( year,month, value = "total")
        
          services = Serviceorder.where([" company_id = ?  AND fecha1 >= ? AND fecha1 <= ?", self.id,"#{year}-#{month}-01 00:00:00", "#{year}-#{month}-31 23:59:59"]).order("id desc")
          ret = 0
          
          for service in services
            puts service.code 
    
            if(value == "subtotal")
              ret += service.subtotal
            elsif(value == "tax")
              ret += service.tax
            elsif(value == "detraccion")
            ret += service.detraccion
            else 
              
              ret += service.total
            end
          end
          
          return ret
        end
       # Return value 
       def get_purchases_year_month_value( year,month, value = "total_amount")
        
          purchases = Purchase.where(["purchases.balance > 0  and  company_id = ?  AND date2 >= ? AND date2 <= ?", self.id,"2000-01-01 00:00:00", "#{year}-#{month}-31 23:59:59"]).order("id desc")
          ret = 0
          
          for purchase in purchases
            
            if(value == "subtotal")
              ret += purchase.subtotal
            elsif(value == "tax")
              ret += purchase.tax
            else
              ret += purchase.total_amount
            end
          end
          
          return ret
        end
    
        def get_purchases_year_month( year,month)
        
          @purchases = Purchase.where(["purchases.balance > 0  and  company_id = ?  AND date2 >= ? AND date2 <= ?", self.id,"2000-01-01 00:00:00", "#{year}-#{month}-31 23:59:59"]).order("supplier_id")  
          
          return @purchases 
        end
        def get_purchases_day(fecha1,fecha2)
          @purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ]).order(:supplier_id,:moneda_id,:date1)    
          return @purchases 
        end
    
        def get_purchases_day_tipo(fecha1,fecha2,tipo)
          if tipo =="2" 
            @purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ? and processed = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59","1"]).order(:supplier_id,:moneda_id,:date1)    
          else   
            @purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ?  AND tipo = ?  and processed = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", tipo, "1"]).order(:supplier_id,:moneda_id,:date1)
          end 
          return @purchases 
        end
        def get_purchases_day_tipo2(fecha1,fecha2,tipo,proveedor)
          
          if tipo =="2" 
            @purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ? and processed = ? and supplier_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59","1",proveedor ]).order(:supplier_id,:moneda_id,:date1)    
          else   
            @purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ?  AND tipo = ?  and processed = ? and supplier_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", tipo, "1",proveedor]).order(:supplier_id,:moneda_id,:date1)
          end 
          return @purchases 
        end
        
        def get_purchases_day_all(fecha1,fecha2,proveedor)
          
          @purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ? and processed = ? and supplier_id = ? and  round(CAST(balance AS numeric),2) > 0 ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59","1",proveedor ]).order(:supplier_id,:moneda_id,:date1)       
          return @purchases 
        end
        
        
        
        def get_purchases_day_categoria(fecha1,fecha2,moneda,tipo)
          
          if tipo == "0"
            @purchases = Purchase.find_by_sql(['Select products.products_category_id,SUM(purchase_details.total) AS TOTAL
            from purchase_details   
            INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
            INNER JOIN products ON purchase_details.product_id = products.id
            WHERE purchases.date1 >= ? and purchases.date1 <= ?  and purchases.moneda_id= ?  and purchases.tipo = ?
            GROUP BY products.products_category_id  
            ORDER BY products.products_category_id  ' , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda,tipo ])
          else
            @purchases = Purchase.find_by_sql(['Select servicebuys.code,SUM(purchase_details.total) AS TOTAL
            from purchase_details   
            INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
            INNER JOIN servicebuys ON servicebuys.id = products.id
            WHERE purchases.date1 >= ? and purchases.date1 <= ?  and purchases.moneda_id= ?  and purchases.tipo = ?
            GROUP BY servicebuys.code  
            ORDER BY servicebuys.code  ' , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda,tipo ])
            
          end 
          return @purchases
          
        end
    
      def get_purchases_day_categoria2(fecha1,fecha2,moneda,tipo)
        
        
          if  tipo == "0"
              @purchases = Purchase.find_by_sql(['Select purchase_details.*,products.products_category_id,purchases.supplier_id,purchases.documento,
              purchases.document_id,purchases.date1
              from purchase_details   
              INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
              INNER JOIN products ON purchase_details.product_id = products.id
              WHERE purchases.date1 >= ? and purchases.date1 <= ?  and purchases.moneda_id= ?  and purchases.tipo = ?
              ORDER BY products.products_category_id,purchases.supplier_id,purchases.date1,purchases.document_id,purchases.documento' , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda,tipo ])
          else  
              @purchases = Purchase.where(["  date1 >= ? and date1 <= ?  AND tipo = ?  and processed = ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59", tipo, "1"]).order(:supplier_id,:moneda_id,:date1)
          end 
          
          return @purchases
          
        end
    
    
        def get_purchases_by_day(fecha1,fecha2,moneda)
        
          @purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , ]).order(:id,:moneda_id)    
          return @purchases 
        end
    
        def get_purchases_by_day_value(fecha1,fecha2,moneda,value='total_amount')
        
          purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , ]).order(:id,:moneda_id)    
    
          ret = 0
          for purchase in purchases
            
            if(value == "subtotal")
              ret += purchase.subtotal
            elsif(value == "tax")
              ret += purchase.tax
              
            elsif(value == "balance")
              ret += purchase.balance
            
            else
              ret += purchase.total_amount
            end
          end
          
          return ret
    
    
        end
        
       def get_purchases_by_day_value_supplier(fecha1,fecha2,moneda,value='total_amount',supplier)
        
          purchases = Purchase.where([" company_id = ? AND date1 >= ? and date1 <= ? and moneda_id = ? and supplier_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , supplier ]).order(:id,:moneda_id)    
    
          ret = 0
          for purchase in purchases
            
            if(value == "subtotal")
              ret += purchase.subtotal
            elsif(value == "tax")
              ret += purchase.tax
            elsif(value == "balance")
              ret += purchase.balance 
            
            else
              ret += purchase.total_amount
            end
          end
          
          return ret
    
        end 
    
       def get_purchase_day_value2(fecha1,fecha2,supplier,moneda,value="total")
    
          facturas = Purchase.where(["company_id = ? AND date1 >= ? and date1<= ? and supplier_id = ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59",supplier, moneda ]).order(:supplier_id,:moneda_id)
          if facturas
          ret=0  
          for factura in facturas
            
            if(value == "subtotal")
              ret += factura.subtotal
            elsif(value == "tax")
              ret += factura.tax
            elsif(value == "balance")
              ret += factura.balance 
            
            else         
              ret += factura.total_amount.round(2)
            end
          end
          end 
    
          return ret
          
       end 
    
       def get_purchases_pendientes_day(fecha1,fecha2)
    
          @facturas = Purchase.where(["balance > 0  and  company_id = ? AND date1 >= ? and date1<= ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"]).order(:supplier_id,:moneda_id,:date1)
          return @facturas
          
       end 
    
       def get_purchases_pendientes_day_supplier_1(fecha1,fecha2,cliente)
          @facturas = Purchase.where(["balance > 0  and  company_id = ? AND date1 >= ? and date1<= ? and supplier_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", cliente ]).order(:supplier_id,:moneda_id,:date1)
          return @facturas
    
    
       end 
    
       
       def get_purchaseorders_day_value2(fecha1,fecha2,supplier,moneda,value )
    
          facturas = Purchaseorder.where(["company_id = ? AND fecha1 >= ? and fecha1<= ? and supplier_id = ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59",supplier, moneda ]).order(:supplier_id,:moneda_id)
          if facturas
          ret=0  
          for factura in facturas
            
            if(value == "subtotal")
              ret += factura.subtotal
            elsif(value == "tax")
              ret += factura.tax
            else         
              ret += factura.total.round(2)
            end
          end
          end 
    
          return ret
          
       end 
    
      def get_purchases_pendientes_day_supplier(fecha1,fecha2,value,moneda)
    
          facturas = Purchase.where(["balance>0  and  company_id = ? AND date1 >= ? and date1 <= ? AND customer_id = ? and moneda_id =  ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", value , moneda ]).order(:customer_id,:moneda_id)
    
          if facturas
          ret=0  
          for factura in facturas
            
            if(value == "subtotal")
              ret += factura.subtotal
            elsif(value == "tax")
              ret += factura.tax
            else         
              ret += factura.balance.round(2)
            end
          end
          end 
    
          return ret    
       end 
    
    
       def get_supplier_payments_value2(fecha1,fecha2)
    
          ret = 0 
          if facturas 
          ret=0  
            for factura in facturas      
    
                ret += factura.total
    
            end
          end 
          return ret    
       end 
    
    
        
        # Return value for user
        def get_invoices_value_user(user, year, value = "total")
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND user_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, user.id, "#{year}-01-01 00:00:00", "#{year}-12-31 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        # Return value for user in specific date
        def get_invoices_value_user_date(user, date, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND user_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, user.id, "#{date} 00:00:00", "#{date} 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        # Return products for company
        def get_products()
          products = Product.where(company_id: self.id).order(:name)
          
          return products
        end
    
        # Return products for company
        def get_products2()
          products = Product.where(company_id: self.id).order(:products_category_id,:code)    
          return products
        end
    
        
        # Return products for company
        def get_products_dato(id)
          products = Product.find_by(company_id: self.id,id: id)    
          if products.unidad == nil
          return products.name + " - "   
          else     
          return products.name + " - "+products.unidad 
          end 
        end
        
        # Return value for product
        def get_invoices_value_product(product, year, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, "#{year}-01-01 00:00:00", "#{year}-12-31 23:59:59"])
          ids = []
          
          for invoice in invoices
            ids.push(invoice.id)
          end
          
          begin
            invoice_products = InvoiceProduct.where(["product_id = ? AND invoice_id IN (#{ids.join(",")})", product.id])
          rescue
            return 0
          end
          
          ret = 0
          
          for ip in invoice_products
            if(value == "quantity")
              ret += ip.quantity
            else
              ret += ip.total
            end
          end
          
          return ret
        end
        
        # Return value for product for exact date
        def get_invoices_value_product_date(product, date, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, "#{date} 00:00:00", "#{date} 23:59:59"])
          ids = []
          
          for invoice in invoices
            ids.push(invoice.id)
          end
          
          begin
            invoice_products = InvoiceProduct.where(["product_id = ? AND invoice_id IN (#{ids.join(",")})", product.id])
          rescue
            return 0
          end
          
          ret = 0
          
          for ip in invoice_products
            if(value == "quantity")
              ret += ip.quantity
            else
              ret += ip.total
            end
          end
          
          return ret
        end
        
        # Get customers for Company
        def get_customers()
          customers = Customer.where("company_id =? and tipo <> ?","1","3").order(:name)
    
          return customers
        end
        def get_customers_pago()
          customers = Customer.where(company_id: self.id,tipo:"2").order(:name)
          return customers
        end
        
        def get_customers_contado()
          customers = Customer.where(company_id: self.id,tipo:"3").order(:name)
          return customers
        end
        def get_customer_name(customer_id )
          customers = Customer.find_by(company_id: self.id,id:customer_id)

          return customers
        end
        def get_customer_account(customer_id )
          customers = Customer.find_by(company_id: self.id,id:customer_id)

          return customers.account
        end
        
        
        # Get value for customer in year
        def get_invoices_value_customer(customer, year, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND customer_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, customer.id, "#{year}-01-01 00:00:00", "#{year}-12-31 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
    
        # Return value for customer in specific date
        def get_invoices_value_customer_date(customer, date, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND customer_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, customer.id, "#{date} 00:00:00", "#{date} 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
    
        # Get locations for company
        def get_report_locations()
          locations = Location.where(company_id: self.id)
    
          return locations
        end
    
        # Return value for location in year
        def get_invoices_value_location(location, year, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND location_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, location.id, "#{year}-01-01 00:00:00", "#{year}-12-31 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        # Return value for location specific date
        def get_invoices_value_location_date(location, date, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND location_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, location.id, "#{date} 00:00:00", "#{date} 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        # Returns divisions for company
        def get_report_divisions()
          divisions = Division.where(company_id:  self.id)
    
          return divisions
        end
        
        # Return value for a division year
        def get_invoices_value_division(division, year, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND division_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, division.id, "#{year}-01-01 00:00:00", "#{year}-12-31 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        # Return value for a division exact date
        def get_invoices_value_division_date(division, date, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND division_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, division.id, "#{date} 00:00:00", "#{date} 23:59:59"])
          ret = 0
          
          for invoice in invoices
            if(value == "subtotal")
              ret += invoice.subtotal
            elsif(value == "tax")
              ret += invoice.tax
            else
              ret += invoice.total
            end
          end
          
          return ret
        end
        
        # Get profit, cost and taxes for a series of invoices in a date
        def get_ptc_value_date(date, value)
          date_arr = date.split("-")
          year = date_arr[0]
          month = date_arr[1]
          
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, "#{year}-#{month}-01 00:00:00", "#{year}-#{month}-31 23:59:59"])
          ret = 0
          
          for invoice in invoices
            products = invoice.get_products
            
            for product in products
              if(value == "profit")
                ret += product.profit * product.curr_quantity
              elsif(value == "tax")
                ret += product.tax * product.curr_quantity
              elsif(value == "price")
                ret += product.price * product.curr_quantity
              elsif(value == "total")
                ret += (product.price + product.tax) * product.curr_quantity
              else
                ret += product.cost * product.curr_quantity
              end
            end
          end
          
          return ret
        end
        
        # Get profit, cost and taxes for a series of invoices in an exact date
        def get_ptc_value_exact_date(date, value)
          invoices = Invoice.where(["invoices.return = '0' AND company_id = ? AND date_processed >= ? AND date_processed <= ?", self.id, "#{date} 00:00:00", "#{date} 23:59:59"])
          ret = 0
          
          for invoice in invoices
            products = invoice.get_products
            
            for product in products
              if(value == "profit")
                ret += product.profit * product.curr_quantity
              elsif(value == "tax")
                ret += product.tax * product.curr_quantity
              elsif(value == "price")
                ret += product.price * product.curr_quantity
              elsif(value == "total")
                ret += (product.price + product.tax) * product.curr_quantity
              else
                ret += product.cost * product.curr_quantity
              end
            end
          end
          
          return ret
        end
    
    
        def truncate(truncate_at, options = {})
        return dup unless length > truncate_at
    
        options[:omission] ||= '...'
        length_with_room_for_omission = truncate_at - options[:omission].length
        stop =        if options[:separator]
            rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
          else
            length_with_room_for_omission
          end
    
        "#{self[0...stop]}#{options[:omission]}"
        end
    
      def get_purchaseorder_detail2(fecha1,fecha2)
          @purchaseorders = Purchaseorder.where([" fecha1 >= ? and fecha1 <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ]).order(:supplier_id,:moneda_id,:fecha1)
          return @purchaseorders    
       end 
        
    
       def get_purchaseorder_detail(fecha1,fecha2)
          @purchaseorders = Purchaseorder.where([" fecha1 >= ? and fecha1 <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ]).order(:fecha1)
          return @purchaseorders    
       end 
    
       def get_orden_detalle(id)
          
          @purchaseorders = PurchaseorderDetail.where(:purchaseorder_id=>id)
          return @purchaseorders
          
       end 
       def get_orden_detalle2(id)
          
          @purchaseorders = ServiceorderService.where(:serviceorder_id=>id)
          return @purchaseorders
          
       end 
    
       def get_purchase_detalle(id)    
          @purchases = PurchaseDetail.where(:purchase_id=>id)
          return @purchases
          
       end 
    
    
        def get_purchaseorders_day_value(fecha1,fecha2,value = "balance",moneda)
    
          facturas = Purchaseorder.where(["balance>0  and  company_id = ? AND date1 >= ? and date1<= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda ]).order(:supplier_id,:moneda_id)
          if facturas
          ret=0  
          for factura in facturas
            
            if(value == "subtotal")
              ret += factura.subtotal
            elsif(value == "tax")
              ret += factura.tax
            else         
              ret += factura.balance.round(2)
            end
          end
          end 
    
          return ret
          
       end 
       def get_purchaseorders_totalday_value(fecha1,fecha2,value = "total",moneda)
    
          facturas = Purchaseorder.where(["company_id = ? AND fecha1 >= ? and fecha1<= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda ]).order(:supplier_id,:moneda_id)
          if facturas
          ret=0  
          for factura in facturas
            
            if(value == "subtotal")
              ret += factura.subtotal
            elsif(value == "tax")
              ret += factura.tax
            else         
              ret += factura.total.round(2)
            end
          end
          end 
    
          return ret    
       end 
    
       def get_stocks_inventarios4(product1)
         
          @productExiste = Product.find_by_sql(['Select products.*,
            stocks.quantity  
            from products 
            INNER JOIN stocks ON products.id = stocks.product_id where products.products_category_id = ? order by products.code ', product1 ])
          
          return @productExiste 
          
       end
       
    
       ###INVENTARIO  STOCKS 
    
       def get_stocks_inventarios2(fecha1,fecha2,product1,estado)
    
    
          MovementDetail.delete_all
    
          @productExiste = Product.where(:products_category_id=> product1) 
    
           for existe in @productExiste
    
              product =  MovementDetail.find_by(:product_id => existe.id)
    
              if product 
              else   
                detail  = MovementDetail.new(:fecha=>fecha1 ,:stock_inicial=>0,:ingreso=>0,:salida =>0,
               :price=> 0 ,:product_id=> existe.id,:tm=>"4",:stock_final =>0 )
                detail.save       
              end         
           end    
    
    
           ######################################################################3
           ##saldo inicial
           ######################################################################3 
    
           @inv = Inventario.where('fecha < ?',"#{fecha1} 00:00:00")  
    
          
           for inv in @inv       
    
              @invdetail = InventarioDetalle.where(:inventario_id=>inv.id)
    
              for invdetail in @invdetail 
    
                
                 movdetail  = MovementDetail.find_by(:product_id=>invdetail.product_id)          
    
                if movdetail
    
                  if invdetail.cantidad == nil
                  movdetail.stock_inicial += 0   
                  else
                  movdetail.stock_inicial += invdetail.cantidad
                  end
    
                  if invdetail.precio_unitario == nil
                    movdetail.price = 0  
                 else 
                    movdetail.price = invdetail.precio_unitario
                  end
    
                  movdetail.save           
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
                end
              
              end 
            end 
    
            #ingresos
           @ing = Purchase.where('date1 <  ?',"#{fecha1} 00:00:00")
    
           for ing in @ing    
                $lcFecha = ing.date1.to_date
                $lcmoneda = ing.moneda_id
    
              @ingdetail=  PurchaseDetail.where(:purchase_id=>ing.id)
    
              for detail in @ingdetail 
                $lcPreciosinigv = detail.price_without_tax
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)
    
                if movdetail
                  if detail.quantity == nil
                    movdetail.stock_inicial += 0   
                  else 
                    movdetail.stock_inicial +=  detail.quantity
                  end 
    
                  if detail.price_without_tax == nil
                   movdetail.price = 0 
                  else
                    if $lcmoneda != nil                 
                      if $lcmoneda == 2
                        movdetail.price = detail.price_without_tax
                      else
                        @dolar = Tipocambio.find_by(["dia  >= ? and dia <= ? ", "#{$lcFecha} 00:00:00","#{$lcFecha} 23:59:59" ])
                        if @dolar 
                          movdetail.price = $lcPreciosinigv * @dolar.compra
                        else
                          movdetail.price = 0                  
                        end 
                      end    
                    end 
                  end 
    
                  
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
                      
              end 
           end 
    
           #salidas 
          @sal  = Output.where('fecha <  ?',"#{fecha1} 00:00:00")
    
           for sal in @sal     
              @saldetail=  OutputDetail.where(:output_id=>sal.id)
    
              for detail in @saldetail 
              
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)          
    
                if movdetail
    
                  if detail.quantity == nil
                    movdetail.stock_inicial += 0   
                  else
                    movdetail.stock_inicial -= detail.quantity
                  end
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
              end 
           end 
                #ventas
          @ventas  = Market.where('fecha < ?',"#{fecha1} 00:00:00")
          
          
    
           for sal in @ventas  
           
              @product_id = Product.find_by(code: sal.cod_prod )
              
                movdetail  = MovementDetail.find_by(:product_id => @product_id.id )
    
                if movdetail
    
                  if sal.cantidad == nil
                    movdetail.stock_inicial += 0   
                  else
                    movdetail.stock_inicial -= sal.cantidad
                  end
                  movdetail.save           
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
              
           end 
           
    
           
    
         #actualiza ajustes de inventarios
         
         
           @ajuste  = Ajust.where('fecha1 <  ?',"#{fecha1} 00:00:00")
    
           for ajuste  in @ajuste
              @ajustedetail= AjustDetail.where(:ajust_id=>ajuste.id)
    
              for detail in @ajustedetail 
              
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)          
    
                if movdetail
    
                  if detail.quantity == nil
                  
                    movdetail.stock_inicial += 0   
                  else
                    if detail.quantity > 0
                      movdetail.stock_inicial += detail.quantity
                    else
                      movdetail.stock_inicial -= detail.quantity*-1
                    end     
                    
                  end
              
       
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
              end 
           end 
       # Varillaje
       
       
       @varilla = Varillaje.where(["fecha < ? ", "#{fecha1} 00:00:00" ])
       
       
       for detalle  in @varilla
              
               producto_value = detalle.tanque.product.id
               @fecha = detalle.fecha.to_date 
               
               qty  =  detalle.inicial + detalle.get_compras(@fecha,producto_value)  - detalle.get_ventas(@fecha,detalle.tanque.product.id)- detalle.get_ventas_vale_directo_producto(@fecha,detalle.tanque.product.code.to_s,"qty")
               dife =  detalle.varilla - qty
               
                movdetail  = MovementDetail.find_by(:product_id=> producto_value)          
    
                if movdetail
    
                  if qty == nil
                  
                      movdetail.stock_inicial += 0   
                  else
                    
                      movdetail.stock_inicial += dife 
                    
                  end
              
       
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
              
       
       
       end 
    
    
         
        #actualiza  el costo de la salida
           @inv = Inventario.where('fecha >= ? and  fecha <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")  
           for inv in @inv 
              $lcFecha =inv.fecha 
    
              @invdetail=  InventarioDetalle.where(:inventario_id=>inv.id)
              for invdetail in @invdetail 
                 movdetail  = MovementDetail.find_by(:product_id=>invdetail.product_id)          
              if movdetail   
                  movdetail.ingreso += invdetail.cantidad
                  movdetail.price = invdetail.precio_unitario
                  movdetail.save 
              else
              #  detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>invdetail.cantidad,
              #    :salida => 0,
              #  :price=>invdetail.precio_unitario,:product_id=> invdetail.product_id,:tm=>"1")
              #  detail.save 
              end   
    
              end 
            end 
            #ingresos0 
           @ing = Purchase.where('date1>= ? and date1 <= ?  ',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
    
           for ing in @ing
    
              $lcFecha  = ing.date1.strftime("%F") 
              $lcmoneda = ing.moneda_id
    
              @ingdetail=  PurchaseDetail.where(:purchase_id=>ing.id)
          
              for detail in @ingdetail 
                $lcPreciosinigv = detail.price_without_tax
    
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)          
                if movdetail
                  if detail.quantity == nil 
                    movdetail.ingreso = 0
                  else 
                    movdetail.ingreso += detail.quantity
                  end 
    
                  if detail.price_without_tax == nil
                   movdetail.price = 0 
                  else
                    if $lcmoneda != nil                 
                      if $lcmoneda == 2
                        movdetail.price = detail.price_without_tax
                      else
                        @dolar = Tipocambio.find_by(["dia  >= ? and dia <= ? ", "#{$lcFecha} 00:00:00","#{$lcFecha} 23:59:59" ])
                        if @dolar 
                          movdetail.price = $lcPreciosinigv * @dolar.compra
                        else
                          movdetail.price = 0                  
                        end 
                      end    
                    end 
                  end 
                  movdetail.save           
                else     
               # detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>detail.quantity,:salida => 0,
               #   :price=>detail.price_without_tax,:product_id=> detail.product_id,:tm =>"2")
               # detail.save 
                end
    
              end 
           end 
    
           #ventas
          @ventas  = Market.where('fecha>= ? and fecha <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
    
           for sal in @ventas  
           
            if sal == nil 
            else 
                @product_id = Product.find_by(code: sal.cod_prod )
                movdetail  = MovementDetail.find_by(:product_id=> @product_id.id )
    
                if movdetail
    
                  if sal.cantidad == nil
                    movdetail.salida = 0   
                  else
                    movdetail.salida += sal.cantidad 
                  end
                    movdetail.save           
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
            end 
            
           end 
           
           
                #salidas
          @sal  = Output.where('fecha>= ? and fecha <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
    
           for sal in @sal 
              $lcFecha = sal.fecha 
    
              @saldetail=  OutputDetail.where(:output_id=>sal.id)
    
              for detail in @saldetail 
    
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)
    
                if movdetail
    
                  if detail.quantity == nil
                    movdetail.salida = 0   
                  else
                    movdetail.salida += detail.quantity
                  end
                    movdetail.save           
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
              end 
           end 
    
       
       @varilla = Varillaje.where(["fecha >= ? and fecha <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"  ])
       
       
       for detalle  in @varilla
              
               producto_value = detalle.tanque.product.id
               @fecha = detalle.fecha.to_date 
               
               qty  =  detalle.inicial + detalle.get_compras(@fecha,producto_value)  - detalle.get_ventas(@fecha,detalle.tanque.product.id)- detalle.get_ventas_vale_directo_producto(@fecha,detalle.tanque.product.code.to_s,"qty")
               dife =  detalle.varilla - qty
               
                movdetail  = MovementDetail.find_by(:product_id=>producto_value)          
    
                if movdetail
    
                  if qty == nil
                  
                      movdetail.salida += 0  
                      movdetail.ingreso += 0  
                  else
                     if dife > 0  
                       movdetail.ingreso += dife
                     else
                       movdetail.salida  += dife 
                     end 
                  end
              
       
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
              
       
       
       end 
    
           
      # ajustes de inventarios
    
    
          @ajuste = Ajust.where('fecha1>= ? and fecha1 <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
    
           for sal in @ajuste
              $lcFecha = sal.fecha1 
    
              @ajustedetail=  AjustDetail.where(:ajust_id=>sal.id)
    
              for detail in @ajustedetail 
    
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)
    
                if movdetail
    
                  if detail.quantity == nil
                    movdetail.salida += 0  
                    movdetail.ingreso += 0  
                  else
                    if detail.quantity > 0
                      movdetail.ingreso += detail.quantity
                    else
                      movdetail.salida  += detail.quantity*-1
                    end     
                      
                  end
                    movdetail.save           
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
              end 
           end 
          
           if estado=="1"
              @inv1 = MovementDetail.all.order(:product_id,:fecha)
              
              for stock1 in @inv1
                  a0= stock1.product_id 
                  a1= stock1.stock_inicial
                  a2= stock1.ingreso
                  a3= stock1.salida
                  a4= a1+a2-a3
                  
                  a5=Stock.find_by(:product_id=> a0)
                  if a5
                    a5.quantity = a4
                    a5.save
                  else
                    
                    a6= Stock.new(:store_id =>"1",:state=>"Lima",:product_id=>a0,:quantity=>a4)
                    a6.save 
                    
                  end 
                  
              end 
           end 
    
           # AGREGA LOS QUE NO TIENEN MOVIMIENTO 
          
            @inv = MovementDetail.all.order(:product_id,:fecha)
          return @inv 
    
       end
    
    
       ###INVENTARIO  STOCKS  DETALLADO
    
       def get_stocks_inventarios3(fecha1,fecha2,product1)
    
          MovementDetail.delete_all
    
          @productExiste = Product.where(:products_category_id=> product1) 
    
           for existe in @productExiste
              product =  MovementDetail.find_by(:product_id => existe.id)
              if product
              else
                detail  = MovementDetail.new(:fecha=>fecha1 ,:stock_inicial=>0,:ingreso=>0,:salida =>0,:stock_final =>0,document_id: 12,
               :costo_ingreso=> existe.price ,:costo_salida=> 0,:costo_saldo => 0, :product_id=> existe.id,:tm=>"16",:documento=>"SALDO INICIAL",:amount=>0,:to=>"01" )
                detail.save
              end        
           end    
    
          ######################################################################3
           ##saldo inicial
           ######################################################################3 
    
           @inv = Inventario.where('fecha < ?',"#{fecha1} 00:00:00")  
    
          
           for inv in @inv       
    
              @invdetail = InventarioDetalle.where(:inventario_id=>inv.id)
    
              for invdetail in @invdetail 
    
                 movdetail  = MovementDetail.find_by(:product_id=>invdetail.product_id)          
    
                if movdetail
    
                  if invdetail.cantidad == nil
                  movdetail.ingreso += 0   
                  else
                  movdetail.ingreso += invdetail.cantidad
                  movdetail.amount +=  invdetail.cantidad
                  end
    
                  if invdetail.precio_unitario == nil
                    movdetail.costo_ingreso = 0  
                 else 
                    movdetail.costo_ingreso = invdetail.precio_unitario
                  end
    
                  movdetail.save           
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
                end
              
              end 
            end 
    
            #ingresos
           @ing = Purchase.where('date1 <  ?',"#{fecha1} 00:00:00")
    
           for ing in @ing    
                $lcFecha  = ing.date1.strftime("%F")
                $lcmoneda = ing.moneda_id
    
              @ingdetail=  PurchaseDetail.where(:purchase_id=>ing.id)
    
              for detail in @ingdetail 
                $lcPreciosinigv = detail.price_without_tax
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)
               
                if movdetail
                  if detail.quantity == nil
                    movdetail.ingreso  += 0   
                  else 
                    movdetail.ingreso  +=  detail.quantity
                    movdetail.amount +=    detail.quantity
                  end 
    
                  if detail.price_without_tax == nil
                   movdetail.costo_ingreso = 0 
                  else
                    if $lcmoneda != nil                 
                      if $lcmoneda == 2
                        movdetail.costo_ingreso = detail.price_without_tax
                      else
                        @dolar = Tipocambio.find_by(["dia  >= ? and dia <= ? ", "#{$lcFecha} 00:00:00","#{$lcFecha} 23:59:59" ])
                        if @dolar 
                          movdetail.costo_ingreso = $lcPreciosinigv * @dolar.compra
                        else
                          movdetail.costo_ingreso = 0                  
                        end 
                      end    
                    end 
                  end 
    
                  
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
                      
              end 
           end 
           #ventas
          @ventas  = Factura.where('fecha <  ?',"#{fecha1} 00:00:00")  
          
           for sal in @ventas      
              @venta_detail=  FacturaDetail.where(:factura_id=>sal.id)
    
              for detail in @venta_detail 
              
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)          
    
                if movdetail
    
                  if detail.quantity == nil
                    movdetail.ingreso += 0   
                  else
                    movdetail.ingreso -= detail.quantity
                    movdetail.amount  -= detail.quantity
                  end
    
       
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
              end 
           end 
    
    
           #salidas 
          @sal  = Output.where('fecha <  ?',"#{fecha1} 00:00:00")  
    
           for sal in @sal     
              @saldetail=  OutputDetail.where(:output_id=>sal.id)
    
              for detail in @saldetail 
              
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)          
    
                if movdetail
    
                  if detail.quantity == nil
                    movdetail.ingreso += 0   
                  else
                    movdetail.ingreso -= detail.quantity
                    movdetail.amount  -= detail.quantity
                  end
    
       
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
              end 
           end 
    
         
    
           @ajuste  = Ajust.where('fecha1 <  ?',"#{fecha1} 00:00:00")
    
           for ajuste  in @ajuste
              @ajustedetail= AjustDetail.where(:ajust_id=>ajuste.id)
    
              for detail in @ajustedetail 
              
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)          
    
                if movdetail
    
                  if detail.quantity == nil
                  
                    movdetail.ingreso += 0   
                  else
                    if detail.quantity > 0
                      movdetail.ingreso  += detail.quantity
                      movdetail.amount +=    detail.quantity
                    else
                      movdetail.ingreso -= detail.quantity*-1
                      movdetail.amount +=    detail.quantity*-1
                    end     
                    
                  end
              
       
                  movdetail.save           
    
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end
              
              end 
           end 
    
           #actualiza costo de salida 
         
           @inv = Inventario.where('fecha >= ? and  fecha <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")  
           for inv in @inv 
              $lcFecha =inv.fecha 
    
              @invdetail=  InventarioDetalle.where(:inventario_id=>inv.id)
              for invdetail in @invdetail 
                 movdetail  = MovementDetail.find_by(:product_id=>invdetail.product_id)          
              if movdetail   
                  movdetail.ingreso += invdetail.cantidad
                  movdetail.amount +=    detail.quantity
                  movdetail.costo_ingreso = invdetail.precio_unitario
                  movdetail.save 
              else
              #  detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>invdetail.cantidad,
              #    :salida => 0,
              #  :price=>invdetail.precio_unitario,:product_id=> invdetail.product_id,:tm=>"1")
              #  detail.save 
              end   
    
              end 
            end 
    
            #ingresos
           @ing = Purchase.where('date1>= ? and date1 <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59" )
    
           for ing in @ing
              $lcFecha  = ing.date1.strftime("%F")
    
              $lcmoneda = ing.moneda_id
              $lcDocumentid = ing.document_id
              $lcDocumento  = ing.documento
              puts $lcFecha 
                
              @ingdetail=  PurchaseDetail.where(:purchase_id=>ing.id)
          
              for detail in @ingdetail 
    
                $lcPreciosinigv = detail.price_without_tax
                
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)          
              
                if movdetail
                            
                  
                  if detail.price_without_tax == nil
                    $lcprice = 0 
                  else
                    if $lcmoneda != nil
                      if $lcmoneda == 2
                       $lcprice = detail.price_without_tax
                      else
    
                        @dolar = Tipocambio.find_by(["dia  >= ? and dia <= ? ", "#{$lcFecha} 00:00:00","#{$lcFecha} 23:59:59" ])
                        if @dolar 
                          movdetail.costo_ingreso = $lcPreciosinigv * @dolar.compra
                          $lcprice = $lcPreciosinigv * @dolar.compra
                        else
                          movdetail.costo_ingreso = $lcPreciosinigv      
                          $lcprice = $lcPreciosinigv 
                        end 
    
                      end    
                    end 
                  end 
    
                detail  = MovementDetail.new(:fecha=>$lcFecha,:ingreso=>detail.quantity,:salida => 0,
                :costo_ingreso=>$lcprice,:costo_salida=>0,:costo_saldo=>$lcprice,:product_id=> detail.product_id,:document_id=>$lcDocumentid,
                :documento=>$lcDocumento,:tm =>"02",:amount => detail.quantity,:stock_final=> 0, to: "02")
                detail.save 
              
                else     
                  
                end
    
              end 
           end 
    
           #salidas 
          @sal  = Output.where('fecha>= ? and fecha <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
    
           for sal in @sal 
              $lcFecha     = sal.fecha 
              $lcDocumento = sal.code
              $lcDocumentId = "12"
              puts "salida"
              puts $lcFecha
              @saldetail=  OutputDetail.where(:output_id=>sal.id)
    
              for detail in @saldetail 
    
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)
    
                if movdetail        
                   detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0, :salida=>detail.quantity,
                  :costo_ingreso =>0,:costo_salida =>detail.price,:costo_saldo=>detail.price,:product_id=> detail.product_id,:document_id=> $lcDocumentId,
                  :documento=>$lcDocumento,:tm =>"11",:amount => detail.quantity,:stock_final=> 0, to:"04")
                   detail.save 
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
              end 
           end 
    
           #salidas 
          @ventas  = Factura.where('fecha>= ? and fecha <= ? ',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
    
           for sal in @ventas
              $lcFecha     = sal.fecha 
              $lcDocumento = sal.code
              $lcDocumentId = "01"
              
              @ventasdetail=  FacturaDetail.select("sum(quantity) as quantity","avg(price) as price ",:product_id).where(:factura_id=>sal.id).group(:product_id)
    
              for detail in @ventasdetail 
    
                movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)
    
                if movdetail        
                   detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0, :salida=>detail.quantity,
                  :costo_ingreso =>0,:costo_salida =>detail.price,:costo_saldo=>detail.price,:product_id=> detail.product_id,:document_id=> $lcDocumentId,
                  :documento=>$lcDocumento,:tm =>"11",:amount => detail.quantity,:stock_final=> 0, to:"06")
                   detail.save 
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
              end 
              $lcDocumento = ""
           end 
           
          if product1 == 1 
          @ventas  = Sellvale.where('fecha>= ? and fecha <= ? and td<> ? ',"#{fecha1} 00:00:00","#{fecha2} 23:59:59","N")
    
           for sal in @ventas
              $lcFecha     = sal.fecha 
              $lcDocumento = sal.serie << sal.numero 
              $lcDocumentId = "12"
              
    
              for detail in @ventas
                if detail.cod_prod =='02'
                  lcproductid = 2
                end 
                
                if detail.cod_prod =='03'
                    lcproductid = 3
                end 
                
                if detail.cod_prod =='05'
                    lcproductid = 1
                end 
                
                movdetail  = MovementDetail.find_by(:product_id=> lcproductid)
    
                if movdetail        
                   detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0, :salida=>detail.quantity,
                  :costo_ingreso =>0,:costo_salida =>detail.price,:costo_saldo=>detail.price,:product_id=> lcproductid,:document_id=> $lcDocumentId,
                  :documento=>$lcDocumento,:tm =>"11",:amount => detail.quantity,:stock_final=> 0, to:"06")
                   detail.save 
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
               lcDocumento = ""
             end 
           end 
          end 
          
          @ajuste = Ajust.where('fecha1>= ? and fecha1 <= ?',"#{fecha1} 00:00:00","#{fecha2} 23:59:59")
    
           for sal in @ajuste
              $lcFecha = sal.fecha1 
              $lcDocumentId = "12"
              $lcDocumento=sal.code 
              puts "ajuste"
              puts $lcFecha
              
              @ajustedetail=  AjustDetail.where(:ajust_id=>sal.id)
    
              for detail in @ajustedetail 
                  lcprice=0
                  lcamount=0
                    lcsalida  = 0  
                    lcingreso = 0  
                  
                  movdetail  = MovementDetail.find_by(:product_id=>detail.product_id)
    
                if movdetail
    
                  if detail.quantity == nil
                    lcsalida  = 0  
                    lcingreso = 0  
                  else
                    if detail.quantity > 0
                      lcingreso = detail.quantity
                    else
                      lcsalida  = detail.quantity*-1
                    end     
                      
                  end
                  
                  detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>lcingreso, :salida=>lcsalida ,
                   :costo_ingreso =>0,:costo_salida=>lcprice,:costo_saldo=>0 , :product_id=> detail.product_id,:document_id=> $lcDocumentId,
                   :documento=>"Inventario",:tm =>"99",:amount=> lcamount ,:stock_final=> 0, to: "05")
                  
                  detail.save           
                else     
                
                  #detail  = MovementDetail.new(:fecha=>$lcFecha ,:ingreso=>0,:salida =>detail.quantity,
                  #:price=>detail.price,:product_id=> detail.product_id,:tm=>"3")
                  #detail.save 
    
                end   
              end 
           end 
           # AGREGA LOS QUE NO TIENEN MOVIMIENTO 
    
            @movactualizar = MovementDetail.where(:document_id=>nil)
             for a in @movactualizar
    
                a.update_columns(:document_id=> 1)
                
             end  
            @movactualizar = MovementDetail.where(:costo_ingreso=>nil)
             for a in @movactualizar
    
                a.update_columns(:costo_ingreso=> 0)
                
             end  
    
           # @inv = MovementDetail.order(:product_id,:fecha,:tm ).includes([:product,:document])
           #@inv = MovementDetail.order(:product_id,:fecha,:tm ).preload([:product,:document])
           # CALCULANDO SALDO - STOCK 
                #  @inv = MovementDetail.all 
      @inv = MovementDetail.order(:product_id,:fecha,:to).joins(:product,:document).select("movement_details.*, products.name as product_name").where("products.products_category_id = ?", product1)
    
      ##
      wkey1 = ""
      wkey2 =  @inv.first.product_id 
      wvar =0
      saldo = 0 
      wcosto = 0
    
      for  a in @inv 
          wkey2 = a.product_id
          
          if wkey1 == wkey2
            saldo  = wvar + a.ingreso - a.salida     
          
            if a.ingreso > 0  
              a.costo_saldo = a.costo_ingreso
              if a.tm == '02'
                wcosto = a.costo_saldo  
              end   
            end
            
            if a.salida > 0  
              a.costo_ingreso = 0 
              a.costo_salida  = wcosto
            end
                        
            a.stock_final = saldo
            a.costo_saldo = wcosto 
            a.save
            wvar = saldo   
         
          else
            
            wkey1 = a.product_id     
            wvar  = 0
            saldo  = wvar + a.ingreso - a.salida    
            a.costo_saldo = a.costo_ingreso 
            a.stock_final = saldo
            a.save 
            
            wvar = saldo
              
            if a.tm =='02' || a.tm == '04' ||  a.tm == '01' ||  a.tm == '16'
              wcosto =a.costo_ingreso
            end 
          end 
          end 
          
          return @inv 
    
       end
    
      def get_stocks_ingresos2   
    
          return @ing 
       end
    
       def get_stocks_salidas2   
           
          return @sal 
       end
       
    
       def get_stocks(categoria)
        @stocks = Stock.find_by_sql(['Select stocks.*
          from stocks 
      RIGHT JOIN products ON stocks.product_id = products.id
      WHERE products.products_category_id = ? ORDER BY products.code  ',categoria ]) 
        return @stocks 
    
       end 
       def get_movement_stocks(fecha1,fecha2,product)
          @movements = MovementDetail.where([" fecha >= ? and fecha <= ?  and product_id = ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59",product ])
    
          return @movements
       end
      def get_salidas_day(fecha1,fecha2,product)
        
          @purchases = Output.find_by_sql(['Select outputs.*,output_details.quantity,output_details.product_id,
          output_details.price,output_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from output_details   
      INNER JOIN outputs ON output_details.output_id = outputs.id
      INNER JOIN products ON output_details.product_id = products.id
      WHERE output_details.product_id = ?  and outputs.fecha > ? and outputs.fecha < ?
      order by outputs.fecha',product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
       
          return @purchases 
    
      end
    
      def get_salidas_day2(fecha1,fecha2,product)
        
          @purchases = Output.find_by_sql(['Select outputs.*,output_details.quantity,output_details.product_id,
          output_details.price,output_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from output_details   
      INNER JOIN outputs ON output_details.output_id = outputs.id
      INNER JOIN products ON output_details.product_id = products.id
      WHERE products.products_category_id = ?  and outputs.fecha >= ? and outputs.fecha <= ?
      order by outputs.fecha',product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
       
          return @purchases 
    
      end
    
      def get_salidas_day3(fecha1,fecha2,product,empleado)
        
          @purchases = Output.find_by_sql(['Select outputs.*,output_details.quantity,
          output_details.price,output_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from output_details   
      INNER JOIN outputs ON output_details.output_id = outputs.id
      INNER JOIN products ON output_details.product_id = products.id
      WHERE outputs.employee_id = ?  and products.products_category_id = ?  and outputs.fecha >= ? and outputs.fecha <= ?
      order by outputs.fecha',empleado,product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
       
          return @purchases 
    
      end
    
    
      def get_salidas_day4(fecha1,fecha2)
        
          @facturas = Factura.find_by_sql(['Select facturas.*,factura_details.quantity,
          factura_details.price,factura_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from factura_details   
          INNER JOIN facturas ON factura_details.factura_id = facturas.id
          INNER JOIN products ON factura_details.product_id = products.id
          WHERE facturas.fecha >= ? and facturas.fecha <= ? 
          order by outputs.fecha', "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
       
          return @facturas 
    
      end
    
    
      def get_salidas_day3_1(fecha1,fecha2,product,placa)
        
          @purchases = Output.find_by_sql(['Select outputs.*,output_details.quantity,
          output_details.price,output_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from output_details   
      INNER JOIN outputs ON output_details.output_id = outputs.id
      INNER JOIN products ON output_details.product_id = products.id
      WHERE outputs.truck_id = ?  and products.products_category_id = ?  and outputs.fecha >= ? and outputs.fecha <= ?
      order by outputs.fecha',placa,product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
       
          return @purchases 
    
      end
      def get_salidas_day3_2(fecha1,fecha2,placa)
        
          @purchases = Output.find_by_sql(['Select outputs.*,output_details.quantity,
          output_details.price,output_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from output_details   
      INNER JOIN outputs ON output_details.output_id = outputs.id
      INNER JOIN products ON output_details.product_id = products.id
      WHERE outputs.truck_id = ?  and outputs.fecha >= ? and outputs.fecha <= ?
      order by outputs.fecha ',placa, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
       
          return @purchases 
    
      end
    
    
      def get_ingresos_day(fecha1,fecha2,product)
        
          @purchases = Purchase.find_by_sql(['Select purchases.*,purchase_details.quantity,purchases.moneda_id,
          purchase_details.price_without_tax as price,purchases.date1 as fecha, products.name as nameproducto,
          products.code as codigo ,purchases.documento as code ,products.unidad,purchase_details.total 
          from purchase_details   
      INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
      INNER JOIN products ON purchase_details.product_id = products.id
      WHERE purchase_details.product_id = ?  and purchases.date1 > ? and purchases.date1 < ? 
      order by purchases.date1 ' ,product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
       
          return @purchases 
      end
    
    
      def get_ingresos_day2(fecha1,fecha2,product)
    
         @purchases = Purchase.find_by_sql(['Select purchases.*,purchase_details.quantity,
          purchase_details.price_without_tax as price,purchases.date1 as fecha, products.name as nameproducto,
          products.code as codigo ,purchases.documento as code ,products.unidad,purchase_details.total,purchases.moneda_id,products.products_category_id
          from purchase_details   
      INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
      INNER JOIN products ON purchase_details.product_id = products.id
      WHERE products.products_category_id = ?  and purchases.date1 >= ? and purchases.date1 <= ? and purchases.processed = ?
      ORDER BY products.code,purchases.date1  ',product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59","1" ])
        
          return @purchases 
    
      end
    
    
      def get_ingresos_day3(fecha1,fecha2)  
          @purchases = Purchaseorder.where(["fecha1 >= ? and fecha1 <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
          return @purchases 
    
      end
    
      def get_ingresos_day4(fecha1,fecha2)
    
         @purchases = Purchase.find_by_sql(['Select purchases.*,purchase_details.quantity,
          purchase_details.price_without_tax as price,purchases.date1 as fecha, products.name as nameproducto,
          products.code as codigo ,purchases.documento as code ,products.unidad,purchase_details.total,
          purchases.moneda_id,products.products_category_id 
          from purchase_details   
      INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
      INNER JOIN products ON purchase_details.product_id = products.id
      WHERE purchases.date1 >= ? and purchases.date1 <= ? and purchases.processed = ? 
      ORDER BY products.products_category_id,products.code  ', "#{fecha1} 00:00:00","#{fecha2} 23:59:59","1" ])
        
          return @purchases 
    
      end
      def get_ajust_detail(fecha1,fecha2,product)
        
          @ajustes = Output.find_by_sql(['Select ajusts.*,ajust_details.quantity,
          products.name as nameproducto,products.code as codigo,products.unidad
          from ajust_details   
          INNER JOIN ajusts ON ajust_details.ajust_id = ajusts.id
          INNER JOIN products ON ajust_details.product_id = products.id
          WHERE ajust_details.product_id = ?  and ajusts.fecha1 > ? and ajusts.fecha1 < ?',product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
          return @ajustes 
    
      end
    
    
      def get_trazabilidad_day(fecha1,fecha2,product)
    
         @purchases1 = Purchase.find_by_sql(['Select purchases.*,purchase_details.quantity,
          purchase_details.price_without_tax as price,purchases.date1 as fecha, products.name as nameproducto,
          products.code as codigo ,purchases.documento as code ,products.unidad,purchase_details.total 
          from purchase_details   
      INNER JOIN purchases ON purchase_details.purchase_id = purchases.id
      INNER JOIN products ON purchase_details.product_id = products.id
      WHERE products.products_category_id = ?  and purchases.date1 >= ? and purchases.date1 <= ? and purchases.processed = ?
      ORDER BY products.code  ',product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59","1" ])
    
       @purchases2 = Output.find_by_sql(['Select outputs.*,output_details.quantity,
          output_details.price,output_details.total,products.name as nameproducto,products.code as codigo,products.unidad
          from output_details   
      INNER JOIN outputs ON output_details.output_id = outputs.id
      INNER JOIN products ON output_details.product_id = products.id
      WHERE products.products_category_id = ?  and outputs.fecha >= ? and outputs.fecha <= ?',product, "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
    
          return @purchases 
    
      end
    
    
      def get_dolar(fecha1) 
        @dolar = Tipocambio.find_by(["dia  >= ? and dia <= ? ", "#{fecha1} 00:00:00","#{fecha1} 23:59:59" ])
        return @dolar 
      end 
    
      def get_lgvs3(fecha1,fecha2)
        
            @lgvs = LgvDelivery.find_by_sql(['Select lgvs.*,lgv_deliveries.lgv_id,lgv_deliveries.compro_id
            from lgv_deliveries
            INNER JOIN lgvs ON lgv_deliveries.lgv_id = lgvs.id
            WHERE lgvs.fecha >= ? and lgvs.fecha <= ? ', "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
            return @lgvs 
      end
    
    
      def get_purchases_pendientes_day_value(fecha1,fecha2,value = "total_amount",cliente,moneda)
    
          facturas = Purchase.where(["balance>0  and  company_id = ? AND date1 >= ? and date1<= ? and moneda_id = ? and supplier_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , cliente ]).order(:supplier_id,:moneda_id)
          if facturas
          ret=0  
          for factura in facturas
            
            if(value == "payable_amount")
              ret += factura.payable_amount
            elsif(value == "tax_amount")
              ret += factura.tax_amount 
            else         
              ret += factura.total_amount.round(2)
            end
          end
          end 
    
          return ret
          
       end 
       
       # Parte diario
       
       def  get_parte_1(fecha) 
         
           @varilla = Varillaje.where(["fecha >= ? and fecha <= ? ", "#{fecha} 00:00:00","#{fecha} 23:59:59"  ]).order(:tanque_id)
         
          return @varilla 
       end 
       def  get_stocks_1(fecha1,fecha2) 
         
           @varilla = Varillaje.where(["fecha >= ? and fecha <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"  ]).order(:tanque_id)
         
          return @varilla 
       end 
       
       def  get_parte_10(fecha1,fecha2)
          @varilla = Varillaje.select("tanque_id").where(["fecha >= ? and fecha <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"  ]).group("tanque_id")
          return @varilla 
       end 
       
       def  get_venta_detallado(fecha1,fecha2)
          @varilla =  Factura.select("facturas.id,facturas.code,facturas.subtotal,facturas.tax,facturas.total").where(["fecha >= ? and fecha <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"  ]).joins("INNER JOIN factura_details ON factura_details.id = facturas.id ")
          return @varilla 
       end 
       
    
       #Vale contado 
       def  get_parte_2(fecha1,fecha2) 
         
           @contado = Sellvale.where(["fecha >= ? and fecha <= ?  and tipo = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"2" ]).order(:cod_prod,:fecha)
         
          return @contado
       end 
       
       #Vale credito todos 
       def  get_parte_4(fecha1,fecha2) 
         
           @contado = Sellvale.find_by_sql(['Select sellvales.* 
           from sellvales
           INNER JOIN customers ON sellvales.cod_cli = customers.account 
           WHERE sellvales.fecha >= ? and sellvales.fecha <= ?  and sellvales.td = ? and sellvales.tipo = ?  and customers.tipo <> ? order by fecha ',"#{fecha1} 00:00:00","#{fecha2} 23:59:59","N","1","2" ])
           
           return @contado
       end 
       def  get_parte_6_1(fecha1,fecha2,customer) 
         
           @contado = Sellvale.find_by_sql(['Select sellvales.* 
           from sellvales
           INNER JOIN customers ON sellvales.cod_cli = customers.account 
           WHERE sellvales.fecha >= ? and sellvales.fecha <= ?  and sellvales.td = ? and sellvales.tipo = ?  and customers.tipo <> ? and customers.id = ?  order by fecha ',"#{fecha1} 00:00:00","#{fecha2} 23:59:59","N","1","2",customer ])
           
           return @contado
       end 
       
       def  get_parte_3(fecha1,fecha2,cliente) 
         
           #@contado = Sellvale.where(["fecha >= ? and fecha <= ?  and tipo = ? and td = ?  and cod_cli = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"1","N",cliente]).order(:cod_prod,:fecha)
           
           
           @contado = Sellvale.find_by_sql(['Select sellvales.* 
           from sellvales
           INNER JOIN customers ON sellvales.cod_cli = customers.account 
           WHERE sellvales.fecha >= ? and sellvales.fecha <= ?  and sellvales.td = ? and sellvales.tipo = ?  and customers.tipo <> ?  and customers.account = ?order by fecha ',"#{fecha1} 00:00:00","#{fecha2} 23:59:59","N","1","2",cliente ])
           
           
           
         
          return @contado
       end 
       
       def  get_parte_5(fecha1,fecha2) 
         
           @contado = Sellvale.where(["fecha >= ? and fecha <= ? and td <> ?  and fpago <> ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"N","1" ]).order(:fecha,:fpago)
         
          return @contado
       end 
       
       def  get_parte_5_b(fecha1,fecha2,tarjeta) 
         
           @contado = Sellvale.where(["fecha >= ? and fecha <= ? and td <> ?  and fpago <> ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"N",tarjeta ]).order(:fecha,:fpago)
         
          return @contado
       end 
       
       #pago adelantado 
       def  get_parte_6(fecha1,fecha2) 
         
           @contado = Sellvale.select("sellvales.*,customers.id as customer_id").where(["fecha >= ? and fecha <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"  ]).order(:fecha).joins("INNER JOIN customers ON sellvales.cod_cli = customers.account AND customers.tipo = '2'  ")
         
          return @contado
       end 
       def  get_parte_6_gln_detalle(fecha1,fecha2,cliente) 
         
           @contado = Sellvale.select("sellvales.*,customers.id as customer_id").where(["fecha >= ? and fecha <= ? and cod_cli = ?", "#{fecha1} 00:00:00","#{fecha2} 23:59:59",cliente  ]).order(:fecha).joins("INNER JOIN customers ON sellvales.cod_cli = customers.account AND customers.tipo = '2'  ")
         
          return @contado
       end 
       
    
       
       #pago adelantado  saldo inicial
       def  get_parte_6b(fecha1,fecha2) 
          ret= 0
          @contado = Sellvale.where(["fecha < ? ", "#{fecha1} 00:00:00"]).order(:cod_prod,:fecha).joins("INNER JOIN customers ON sellvales.cod_cli = customers.account AND customers.tipo = '2' ")
          
         if @contado 
          
          for factura in @contado 
            
              ret += factura.importe.to_f
          
          end
         end 
    
           return ret
           
    
       end 
       #pago adelantado  saldo inicial
       def  get_parte_6_gln_cliente(fecha1,fecha2,cliente) 
          ret= 0
          @contado = Sellvale.where(["fecha < ?  and cod_cli = ?", "#{fecha1} 00:00:00",cliente]).order(:cod_prod,:fecha).joins("INNER JOIN customers ON sellvales.cod_cli = customers.account AND customers.tipo = '2' ")
          
         if @contado 
          
          for factura in @contado 
            
              ret += factura.cantidad 
          
          end
         end 
    
           return ret
           
    
       end 
       
        
       def get_ventas_mayor_anterior(fecha1,fecha2,tipoventa)
         
         facturas  = Factura.where(["fecha >= ? and fecha < ? and tipoventa_id  = ? " , "#{fecha1} 00:00:00","#{fecha2} 00:00:00",tipoventa]).order(:fecha)
         
         if facturas
          ret=0  
          for factura in facturas
            
              ret += factura.total.round(2)
          
          end
         end 
    
           return ret
          
       end 
       
       def get_ventas_mayor_anterior_gln_cliente(fecha1,fecha2,tipo,cliente)
         
         facturas = Factura.find_by_sql(['Select facturas.*,customers.id,customers.name,factura_details.quantity,factura_details.price,factura_details.price_discount,
                    factura_details.total, products.code as product_code, products.name 
                      from facturas 
                      INNER JOIN customers ON facturas.customer_id = customers.id  
                      INNER JOIN factura_details ON facturas.id = factura_details.factura_id
                      INNER JOIN products ON  factura_details.product_id = products.id 
                      WHERE facturas.fecha >= ? and facturas.fecha <= ? and customers.tipo = ? and customers.id= ?', "#{fecha1} 00:00:00",
                      "#{fecha2} 23:59:59",tipo,cliente ])  
            
            
         
         if facturas
          ret=0  
          for factura in facturas
                  
                  ret += factura.quantity.round(2) 
              
          end
         end 
    
           return ret
          
       end 
       
       def get_ventas_mayor_anterior_price_cliente(fecha1,fecha2,tipo,cliente)
         
         facturas = Factura.find_by_sql(['Select facturas.*,customers.id,customers.name,factura_details.quantity,factura_details.price,factura_details.price_discount,
                    factura_details.total, products.code as product_code, products.name 
                      from facturas 
                      INNER JOIN customers ON facturas.customer_id = customers.id  
                      INNER JOIN factura_details ON facturas.id = factura_details.factura_id
                      INNER JOIN products ON  factura_details.product_id = products.id 
                      WHERE facturas.fecha >= ? and facturas.fecha <= ? and customers.tipo = ? and customers.id= ?', "#{fecha1} 00:00:00",
                      "#{fecha2} 23:59:59",tipo,cliente ])  
            
            
        ret =0
        
        if facturas.size > 0 
         return facturas.last.price 
        else
          return 0 
        end 
        
       end 
       
         def  get_ventas_contometros_all(fecha1,fecha2) 
    
           facturas = Sellvale.where(["fecha >= ? and fecha <= ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"]).order(:fecha,:serie,:numero)
           
           
          return facturas
       
       end 
       
       def get_productos_comb
         
         @product = Product.where(products_category_id: 1).order(:code)
         return @product 
       end 
       
       def  get_ventas_contometros_efectivo_sustento2(fecha1,fecha2) 
    
           facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago = ? and td <> ? and tipo <> ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", "1" ,"N","2"]).order(:fecha,:serie,:numero)
           
           
          return facturas
       
       end 
       
       def  get_ventas_contometros_efectivo(fecha1,fecha2) 
    
           facturas = Sellvale.where(["fecha >= ? and fecha <= ? and td <> ?  and tipo<> ? and serie = ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","N","2","BB02"])
           
           if facturas
               
              ret=0  
              for detalle in facturas
                  ret += detalle.importe.to_f
             end 
          end 
    
          return ret
       
       end 
       
       
       def  get_ventas_contometros(fecha1,fecha2)
         
           facturas = Ventaisla.where(["fecha >= ? and fecha <= ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
           
           if facturas
               
              ret=0  
              for detalle in facturas
                  ret += detalle.importe.to_f*-1
             end 
          end 
    
          return ret
       
       end 
       
       
       
       
       def get_ventas_market_total(fecha1,fecha2)
         
         facturas  = Factura.where(["fecha >= ? and fecha <= ? and substring(code,1,4) = ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","BB04"]).order(:fecha)
         
         if facturas
          ret=0  
          for factura in facturas
            
              ret += factura.total.round(2)
          
          end
         end 
    
           return ret
       end 
       
       def get_ventas_colaterales_efe(fecha1,fecha2,tipo )
            ret = 0
           facturas = VentaProducto.where(["fecha >= ? and fecha <= ? and  division_id = ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59",tipo ])
            
             if facturas
             for factura in facturas
              ret += factura.total_efe  
             end 
           end 
           
           return ret 
       end  
       def get_ventas_colaterales_tar(fecha1,fecha2,tipo )
           ret = 0
           facturas = VentaProducto.where(["fecha >= ? and fecha <= ? and division_id = ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59",tipo])
            
             if facturas
               
             for factura in facturas
               
               
              ret += factura.total_tar 
              
                
             end 
             
           end 
           
           return ret 
       end  
       
       
       
       def get_ventas_all_series(fecha1,fecha2)
         
         facturas  = Factura.where(["fecha >= ? and fecha <= ? and substring(code,1,4) <> ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","BB02"]).order(:fecha)
         
         if facturas
          ret=0  
          for factura in facturas
            
              ret += factura.total.round(2)
          
          end
         end 
    
           return ret
       end 
       
       def get_ventas_mayor(fecha1,fecha2,tipoventa)
         
         facturas  = Factura.where(["fecha >= ? and fecha <= ? and tipoventa_id  = ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59",tipoventa]).order(:fecha)
         
         if facturas
          ret=0  
          for factura in facturas
            
              ret += factura.total.round(2)
          
          end
         end 
    
           return ret
          
       end 
       
       
        def  get_ventas_vale_directo(fecha1,fecha2) 
    
           facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", "N","3" ])
           
           
          return facturas 
       
       end
       
       
       def  get_ventas_contometros_adelantado(fecha1,fecha2) 
         
          facturas = Sellvale.where(["fecha >= ? and fecha <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59"  ]).order(:cod_prod,:fecha).joins("INNER JOIN customers ON sellvales.cod_cli = customers.account AND customers.tipo = '2' ")
          
           if facturas
               
              ret=0  
              for detalle in facturas
                   ret += detalle.importe.to_f
             end 
          end 
    
          return ret
       
       end 
       
       
       
       def  get_contado_pendiente(fecha1,fecha2) 
         
           facturas  = Sellvale.where(["fecha >= ? and fecha <= ?  and tipo = ? and processed = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"2","0" ]).order(:cod_prod,:fecha)
         
           if facturas
               
              ret=0  
              for detalle in facturas
                   ret += detalle.importe.to_f
             end 
          end 
    
          return ret
          
       end 
       
       #Vale credito todos pendientes
       def  get_credito_out_fecha(fecha1,fecha2) 
         
           facturas  = Sellvale.where(["fecha >= ? and fecha <= ? and sellvales.tipo = ?  and sellvales.td= ? and processed = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"1","N","1" ]).order(:cod_cli,:fecha,:cod_prod)
           if facturas
               
              ret=0  
              for detalle in facturas
                
               fecha_factura = detalle.get_vale_facturado_fecha
             
                  fecha10 = "#{fecha1}"
                  fecha20 = "#{fecha2}"
                  
                  if fecha_factura != nil 
                  if fecha_factura != ""
             
                    if fecha_factura.to_date < fecha10.to_date or fecha_factura.to_date > fecha20.to_date
              
                      ret += detalle.implista
                    
                  end 
                end 
                end 
             end  
          end 
    
          return ret
          
       end 
       
       
       # Facturas todos pendientes
       def  get_credito_out_fecha2(fecha1,fecha2,tipo) 
         
           facturas  = Factura.where(["fecha >= ? and fecha <= ? and tipo = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,tipo ]).order(:fecha)
           if facturas
               
              ret=0  
              for detalle in facturas
              
               @factura_details = detalle.factura_details
               
              for quote in   @factura_details 
             
                  fecha10 = "#{fecha1}"
                  fecha20 = "#{fecha2}"
                  
                  if quote.sellvale != nil 
                  fecha_vale = quote.sellvale.fecha 
                  
                  if fecha_vale != nil 
                      if fecha_vale != ""
                 
                        if fecha_vale.to_date < fecha10.to_date or fecha_vale.to_date > fecha20.to_date
                  
                          ret += detalle.total 
                        
                       end 
                     end 
                  end 
                 end
               end 
             end  
          end 
    
          return ret
          
       end 
       
       
       #Vale credito todos pendientes
       def  get_credito_out_fecha_detalle(fecha1,fecha2) 
         
           facturas  = Sellvale.where(["fecha >= ? and fecha <= ? and sellvales.tipo = ?  and sellvales.td= ? and processed = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"1","N","1" ]).order(:cod_cli,:fecha,:cod_prod)
           
          return facturas 
          
       end 
       def  get_credito_out_fecha_detalle2(fecha1,fecha2,tipo) 
         
           facturas  = Factura.where(["fecha >= ? and fecha <= ? and  tipo = ?   ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,tipo ]).order(:fecha)
           
          return facturas 
          
       end 
       
       
       #Vale credito todos pendientes
       def  get_credito_pendiente(fecha1,fecha2) 
         
           facturas  = Sellvale.where(["fecha >= ? and fecha <= ? and sellvales.tipo = ?  and sellvales.td= ? and processed = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"1","N","0" ]).order(:cod_cli,:fecha,:cod_prod).joins("INNER JOIN customers ON sellvales.cod_cli = customers.account AND customers.tipo <> '2' ")
           if facturas
               
              ret=0  
              for detalle in facturas
                puts detalle.numero
              
                   ret += detalle.implista
                   
                   
             end 
          end 
    
          return ret
          
       end 
       
       #Vale credito todos pendientes
       def  get_credito_pendiente_detalle(fecha1,fecha2) 
         
           facturas  = Sellvale.where(["fecha >= ? and fecha <= ? and sellvales.tipo = ?  and sellvales.td= ? and processed = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ,"1","N","0" ]).order(:cod_cli,:fecha,:cod_prod).joins("INNER JOIN customers ON sellvales.cod_cli = customers.account AND customers.tipo <> '2' ")
          
    
          return facturas 
          
       end 
       
       def get_diferencia_precio_mes(fecha1)
         
          dife_soles=0
          product0 = Varillaje.last 
          @fecha = fecha1.to_date 
          
          dife_soles = product0.get_ventas_importe(@fecha,product0.tanque.product.id) - product0.get_ventas_contometros_producto_todo(@fecha,product0.tanque.product.code.to_s)-  product0.get_ventas_contometros_descuento_producto(@fecha,product0.tanque.product.code.to_s)    
          return dife_soles
          
       end 
       
       def  get_ventas_contometros_descuento(fecha) 
    
           facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo <> ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","3" ])
           
           if facturas
               
              ret=0  
              for detalle in facturas
                  if detalle.implista > 0
                  ret += detalle.implista - detalle.importe.to_f
               
                end
             end 
          end 
    
          return ret
       
       end 
       def  get_ventas_contometros_descuento_detalle(fecha1,fecha2) 
    
           facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo <> ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59", "N","3" ])
           
    
          return facturas
       
       end 
       
       
      def get_facturas_by_day_value(fecha1,fecha2,moneda,value='total')
        
          purchases = Factura.where([" company_id = ? AND fecha >= ? and fecha <= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , ]).order(:id,:moneda_id)    
    
          ret = 0
          for purchase in purchases
          
            
            if (value == "subtotal")
              
              
              ret += purchase.get_importe_soles1
              
            elsif(value == "tax")
            
              ret += purchase.get_importe_soles2
              
            else
              
              ret += purchase.get_importe_soles
            
            end
          end
          
          return ret
    
    
        end 
        
      def get_facturas_by_day_value2(fecha1,fecha2,moneda,value='total')
        
          purchases = TmpFactura.where([" fecha >= ? and fecha <= ? and moneda_id = ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , ]).order(:id,:moneda_id)    
    
          ret = 0
          for purchase in purchases
          
            
            if (value == "subtotal")
              
              
              ret += purchase.get_importe_soles1
              
            elsif(value == "tax")
            
              ret += purchase.get_importe_soles2
              
            else
              
              ret += purchase.get_importe_soles
            
            end
          end
          
          return ret
    
        end 
        
        
        
        
        def  get_ventas_combustibles(fecha1,fecha2) 
    
           facturas = Ventaisla.where(["fecha >= ?  and fecha <=  ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"  ] ).order(:fecha,:turno)
           
             return facturas 
       
        end 
        
         def  get_ventas_combustibles_fecha(fecha1,fecha2) 
    
            facturas = Ventaisla.select("date(ventaislas.fecha) as fecha_venta").where(["fecha >= ?  and fecha <=  ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"] ).order("fecha_venta").group("fecha_venta")
            return facturas 
            
        end 
        
        def  get_ventas_combustibles_producto(fecha1,fecha2) 
    
            facturas = Sellvale.where(["fecha >= ?  and fecha <=  ?  and td <> ? " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","N"  ] ).order(:fecha,:cod_prod)
           
             return facturas 
        end 
        
        def  get_ventas_colaterales(fecha1,fecha2)
          
    
             facturas = Factura.select("fecha, sum(total) as total_price").where(["fecha >= ?  and fecha <=  ? and substring(code,1,4) = ?" , "#{fecha1}","#{fecha2}","BB04"  ] ).group(:fecha)
    
           
             return facturas 
       
        end 
        
        
        def  get_ventas_adelantado(fecha1,fecha2) 
    
            facturas = Factura.where(["fecha >= ?  and fecha <=  ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"] ).order(:fecha).joins("INNER JOIN customers ON facturas.customer_id = customers.id AND customers.tipo = '2' ")
           
             return facturas 
       
        end 
        
        def  get_ventas_adelantado_cliente(fecha1,fecha2,cliente) 
    
            facturas = Factura.find_by_sql(['Select facturas.*,customers.id,customers.name 
                      from facturas 
                      INNER JOIN customers ON facturas.customer_id = customers.id   
                      WHERE facturas.fecha >= ? and facturas.fecha <= ? and customers.tipo = ?', "#{fecha1} 00:00:00",
                      "#{fecha2} 23:59:59","2" ])  
            
               return facturas 
       
        end 
        def  get_ventas_adelantado_cliente_detalle(fecha1,fecha2,tipo,cliente) 
    
            facturas = Factura.find_by_sql(['Select facturas.*,customers.id,customers.name,factura_details.quantity,factura_details.price,factura_details.price_discount,
                    factura_details.total, products.code as product_code, products.name 
                      from facturas 
                      INNER JOIN customers ON facturas.customer_id = customers.id  
                      INNER JOIN factura_details ON facturas.id = factura_details.factura_id
                      INNER JOIN products ON  factura_details.product_id = products.id 
                      WHERE facturas.fecha >= ? and facturas.fecha <= ? and customers.tipo = ? and customers.id= ?', "#{fecha1} 00:00:00",
                      "#{fecha2} 23:59:59",tipo,cliente ])  
            
               return facturas 
       
        end 
    
        
        def  get_ventas_adelantado_suma(fecha1,fecha2) 
    
            facturas = Factura.where(["fecha >= ?  and fecha <=  ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"] ).order(:fecha).joins("INNER JOIN customers ON facturas.customer_id = customers.id AND customers.tipo = '2' ")
           ret=0 
              if facturas
               
              for detalle in facturas
                  
                  ret += detalle.total 
               
                
             end 
          end 
    
          return ret
       
        end 
        
        
        #Saldo inicial 
        def  get_ventas_adelantado_b(fecha1,fecha2) 
            ret = 0
            @facturas = Factura.where(["fecha <  ?" , "#{fecha1} 00:00:00"] ).order(:fecha).joins("INNER JOIN customers ON facturas.customer_id = customers.id AND customers.tipo = '2' ")
             for detalle in @facturas
                  ret += @facturas.total 
             end 
             
             return ret
       
        end 
        
        def  get_ventas_directa(fecha1,fecha2) 
    
            facturas = Factura.where(["fecha >= ?  and fecha <=  ? and tipoventa_id = ?" , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","2"] ).order(:fecha)
           
             return facturas 
       
        end 
        
        def  get_ventas_all(fecha1,fecha2) 
    
            facturas = Factura.where(["fecha >= ?  and fecha <=  ? and substring(code,1,2) <> ? "  , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","BB"] ).order(:fecha,:code)
           
             return facturas 
       
        end 
        def  get_ventas_all2(fecha1,fecha2,customer) 
    
            facturas = Factura.where(["fecha >= ?  and fecha <=  ? and substring(code,1,2) <> ?  and customer_id = ?"  , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","BB",customer] ).order(:fecha,:code)
           
             return facturas 
       
        end 
          
        
        def  get_ventas_vales(fecha1,fecha2,tipo) 
    
            facturas = Sellvale.where(["fecha >= ?  and fecha <=  ?  and td = ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59","N"] ).order(:fecha,:cod_prod)
           
             return facturas 
       
        end 
        def  get_redencion_1(fecha1,fecha2,customer ) 
    
            facturas = Sellvale.where(["fecha >= ?  and fecha <=  ?  and mpuntos =?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59",customer] ).order(:fecha,:cod_prod)
           
             return facturas 
       
        end 
        
        def get_pago_adelantado(fecha1,fecha2)
          
         
          MovementPay.delete_all
    
          @customerExiste = Customer.where(:tipo=> "2") 
    
           for existe in @customerExiste
    
              product =  MovementPay.find_by(:customer_id => existe.id)
    
              if product 
                
              else    
                
                @contado_adel0 = self.get_parte_6_gln_cliente(fecha1,fecha2,existe.account) # total saldo vales adelantados inicial
                puts "vales contado "
                puts @contado_adel0
                
                @fecha0 = "2018-03-01"
                @contado_adel1 = self.get_ventas_mayor_anterior_gln_cliente(@fecha0,fecha1,"2",existe.id) # total saldo facturas adelantadas inicial
                @contado_adel1_price = self.get_ventas_mayor_anterior_price_cliente(@fecha0,fecha1,"2",existe.id) # total saldo facturas adelantadas inicial
                
                puts "factura saldo "
                puts @contado_adel1
                
                @contado_inicial = @contado_adel1 - @contado_adel0 
          
                
                detail  = MovementPay.new(:fecha=>fecha1 ,:inicial=>0,:abono=>@contado_inicial,:cargo =>0,price: @contado_adel1_price,:saldo=>@contado_inicial,:customer_id=> existe.id,document_id: "12" ,code:"Inicial",cod_prod: "1",description: existe.name,to: 1,import: @contado_adel1* @contado_adel1_price )
                detail.save
                
                @contado_rpt6 = self.get_parte_6_gln_detalle(fecha1,fecha2,existe.account) #pago adelantado detalle 
                
                @factura_adelantada= self.get_ventas_adelantado_cliente_detalle(fecha1,fecha2,"2",existe.id)
                
                #Facturas adelantadas
                for pago in @factura_adelantada
                
                  detail  = MovementPay.new(:fecha=> pago.fecha ,:inicial=>0,:abono=>pago.quantity ,:cargo =>0 ,:saldo=>0,:customer_id=> pago.customer_id,document_id: pago.document_id,
                  code:pago.code, cod_prod: pago.product_code ,price: pago.price,price_discount:pago.price_discount,import: pago.total,import_lista:pago.total,to:2)
                  detail.save       
                
                end 
                
                
                
                # Vales adelantados 
                for pago in @contado_rpt6 
                
                  detail  = MovementPay.new(:fecha=> pago.fecha ,:inicial=>0,:abono=>0,:cargo =>pago.cantidad ,:saldo=>0,:customer_id=> pago.customer_id,
                  document_id: "11",code: pago.serie+"-"+pago.numero , cod_prod: pago.cod_prod,price: pago.precio.to_f,price_discount:pago.precio.to_f,import: pago.importe.to_f,import_lista:pago.implista,to:3)
                  detail.save       
                
                end 
            end 
          end 
                
              
    
           ######################################################################3
           ##saldo inicial
           ######################################################################3 
        
          @inv = MovementPay.order(:customer_id,:fecha,:to)
    
      ##
          wkey1 = ""
          wkey2 =  @inv.first.customer_id 
          wvar =0
          saldo = 0 
          wcosto = 0
        
          for  a in @inv 
              wkey2 = a.customer_id
              
              if wkey1 == wkey2
                saldo  = wvar + a.abono - a.cargo
              
                if a.abono > 0  
                  a.costo_saldo = a.price 
                  if a.document_id == 1
                    wcosto = a.price   
                  end   
                end
                
                if a.cargo > 0  
                  a.costo_ingreso = 0 
                  a.costo_salida  = wcosto
                end
                            
                a.saldo = saldo
                a.costo_saldo = wcosto 
                a.save
                wvar = saldo   
             
              else
                
                wkey1 = a.customer_id     
                wvar  = 0
                saldo  = wvar + a.abono - a.cargo 
                a.costo_saldo = a.costo_ingreso 
                a.saldo = saldo
                a.save 
                
                wvar = saldo
                  
                if a.to == 2 
                  wcosto =a.costo_ingreso
                end 
              end 
              end 
              
              return @inv
              
        end 
        def get_pago_adelantado_cliente(fecha1,fecha2,cliente )
          
         
          MovementPay.delete_all
    
          @customerExiste = Customer.where(:tipo=> "2", id: cliente) 
    
           for existe in @customerExiste
    
              product =  MovementPay.find_by(:customer_id => existe.id)
    
              if product 
                
              else    
                
                @contado_adel0 = self.get_parte_6_gln_cliente(fecha1,fecha2,existe.account) # total saldo vales adelantados inicial
                puts "vales contado "
                puts @contado_adel0
                
                @fecha0 = "2018-03-01"
                @contado_adel1 = self.get_ventas_mayor_anterior_gln_cliente(@fecha0,fecha1,"2",existe.id) # total saldo facturas adelantadas inicial
                @contado_adel1_price = self.get_ventas_mayor_anterior_price_cliente(@fecha0,fecha1,"2",existe.id) # total saldo facturas adelantadas inicial
                
                puts "factura saldo "
                puts @contado_adel1
                
                @contado_inicial = @contado_adel1 - @contado_adel0 
          
                
                detail  = MovementPay.new(:fecha=>fecha1 ,:inicial=>0,:abono=>@contado_inicial,:cargo =>0,price: @contado_adel1_price,:saldo=>@contado_inicial,:customer_id=> existe.id,document_id: "12" ,code:"Inicial",cod_prod: "1",description: existe.name,to: 1,import: @contado_inicial* @contado_adel1_price )
                detail.save
                
                @contado_rpt6 = self.get_parte_6_gln_detalle(fecha1,fecha2,existe.account) #pago adelantado detalle 
                
                @factura_adelantada= self.get_ventas_adelantado_cliente_detalle(fecha1,fecha2,"2",existe.id)
                
                #Facturas adelantadas
                for pago in @factura_adelantada
                
                  detail  = MovementPay.new(:fecha=> pago.fecha ,:inicial=>0,:abono=>pago.quantity,:cargo =>0 ,:saldo=>0,:customer_id=> pago.customer_id,document_id: pago.document_id,
                  code:pago.code, cod_prod: pago.product_code ,price: pago.price,price_discount:pago.price_discount,import: pago.total,import_lista:pago.total,to:2)
                  detail.save       
                
                end 
                
                
                
                # Vales adelantados 
                for pago in @contado_rpt6 
                
                  detail  = MovementPay.new(:fecha=> pago.fecha ,:inicial=>0,:abono=>0,:cargo =>pago.cantidad ,:saldo=>0,:customer_id=> pago.customer_id,
                  document_id: "11",code: pago.serie+"-"+pago.numero , cod_prod: pago.cod_prod,price: pago.precio.to_f,price_discount:pago.precio.to_f,import: pago.importe.to_f,import_lista:pago.implista,to:3)
                  detail.save       
                
                end 
            end 
          end 
                
              
    
           ######################################################################3
           ##saldo inicial
           ######################################################################3 
        
          @inv = MovementPay.order(:customer_id,:fecha,:to)
    
      ##
          wkey1 = ""
          wkey2 =  @inv.first.customer_id 
          wvar =0
          saldo = 0 
          wcosto = 0
        
          for  a in @inv 
              wkey2 = a.customer_id
              
              if wkey1 == wkey2
                saldo  = wvar + a.abono - a.cargo
              
                if a.abono > 0  
                  a.costo_saldo = a.price 
                  if a.document_id == 1
                    wcosto = a.price   
                  end   
                end
                
                if a.cargo > 0  
                  a.costo_ingreso = 0 
                  a.costo_salida  = wcosto
                end
                            
                a.saldo = saldo
                a.costo_saldo = wcosto 
                a.save
                wvar = saldo   
             
              else
                
                wkey1 = a.customer_id     
                wvar  = 0
                saldo  = wvar + a.abono - a.cargo 
                a.costo_saldo = a.costo_ingreso 
                a.saldo = saldo
                a.save 
                
                wvar = saldo
                  
                if a.to == 2 
                  wcosto =a.costo_ingreso
                end 
              end 
              end 
              
              return @inv
              
        end 
        
    
       def get_pendientes_day_value_supplier(fecha1,fecha2,value = "balance",proveedor,moneda)
    
          facturas = Purchase.where(["balance>0  and  company_id = ? AND date1 >= ? and date1 <= ? and supplier_id=? and moneda_id = ? and processed = '1' ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59",proveedor, moneda ]).order(:supplier_id,:moneda_id)
          ret=0  
          
          if facturas
            for factura in facturas
             if factura.document_id != 2
                if(value == "payable_amount")
                  ret += factura.payable_amount
                elsif(value == "tax_amount")
                  ret += factura.tax_amount
                else         
                  ret += factura.balance.round(2)
                end
              else
                if(value == "payable_amount")
                  ret -= factura.payable_amount
                elsif(value == "tax_amount")
                  ret -= factura.tax_amount
                else         
                  ret -= factura.balance.round(2)
                end
              end
            end
          end 
          return ret    
       end 
    
    
    
    
    #***
    end     
    
    
    
    
