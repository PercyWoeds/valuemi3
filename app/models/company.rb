class Company < ActiveRecord::Base
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
     documents = Document.where(company_id: self.id)
       
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
     trucks = Truck.all 
     return trucks
  end
  
  def get_employees()
     employees =  Employee.find_by_sql(['Select id,licencia,full_name   from employees' ])
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
  
  def get_puntos()
    puntos = Punto.all 
    return puntos
  end

  def get_servicebuys()
     servicebuys = Servicebuy.all.order(:id)
     return servicebuys
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

def get_guias_2(fecha1,fecha2)
    @delivery = Delivery.where(["processed<> '4' and  processed <> '2' and company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"]).order(:code)
    return @delivery
 end 

def get_guias_3(fecha1,fecha2)
    @delivery = Delivery.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ? ", self.id, "#{fecha1} 00:00:00", "#{fecha2} 23:59:59"])

    
    return @delivery
 end 

 def get_services_year_month(year,month)
    @serviceorder = Serviceorder.where(["company_id = ? AND fecha1 >= ? AND fecha1 <= ?", self.id, "#{year}-#{month}-01 00:00:00", "#{year}-#{month}-31 23:59:59"])
    return @serviceorder
 end 
## ESTADO DE CUENTA 
 def get_facturas_year_month_day(fecha1)
    @facturas = Factura.where(["company_id = ? AND fecha >= ? and fecha<= ?", self.id, "#{fecha1} 00:00:00","#{fecha1} 23:59:59"])
    return @facturas
    
 end 
## ESTADO DE CUENTA 
 def get_facturas_day(fecha1,fecha2)

    @facturas = Factura.where([" company_id = ? AND fecha >= ? and fecha<= ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"]).order(:id )
    return @facturas
    
 end 
 
 def get_facturas_day_value(fecha1,fecha2,value = "total")

    facturas = Factura.where([" company_id = ? AND fecha >= ? and fecha<= ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"])
    if facturas
    ret=0  
    for factura in facturas
      
      if(value == "subtotal")
        ret += factura.subtotal
      elsif(value == "tax")
        ret += factura.tax
      else         
        ret += factura.total
      end
    end
    end 

    return ret
  
 end 
def get_facturas_day_value_cliente(fecha1,fecha2,cliente,value = "total")

    facturas = Factura.where([" company_id = ? AND fecha >= ? and fecha<= ? and customer_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59",cliente ])
    if facturas
    ret=0  
    for factura in facturas
      
      if(value == "subtotal")
        ret += factura.subtotal
      elsif(value == "tax")
        ret += factura.tax
      else         
        ret += factura.total
      end
    end
    end 

    return ret
  
 end 

## REPORTES DE LIQUIDACION  DE COBRANZA

 def get_customer_payments(fecha1,fecha2)

    @facturas = CustomerPayment.where([" company_id = ? AND fecha1 >= ? and fecha1<= ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"]).order(:id)
    return @facturas
    
 end 

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

 def get_customer_payments_value_otros(fecha1,fecha2,value='factory')
    facturas = CustomerPayment.where(["fecha1 >= ? and fecha1 <= ? ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])        
        ret=0  
        for factura in facturas

          @detail = CustomerPaymentDetail.find(factura.id)

          if(value == "ajuste_debe")
            ret += @detail.ajuste_debe
          elsif(value == "ajuste_haber")
            ret += @detail.ajuste_haber
          else         
            ret += @detail.factory
          end

        end    

    return ret
 end 


## REPORTE DE ESTADISTICAS DE PAGOS pivot

def get_customer_payments2(moneda)

   @facturas = Factura.find_by_sql(["
  SELECT   year_mounth as year_month,
   customer_id,
   SUM(balance) as balance   
   FROM facturas
   WHERE moneda_id = ?
   GROUP BY 2,1
   ORDER BY 2,1 ", moneda])    

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

    if facturas
    ret=0  
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
        days = fact.payment.day 
        fechas2 = factura.fecha + days.days           
        fact.update_attributes(:fecha2=>fechas2)   
    end 

  end
  

 ## Pendientes 

 def get_pendientes_day(fecha1,fecha2)

    @facturas = Factura.where(["balance > 0  and  company_id = ? AND fecha >= ? and fecha<= ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"]).order(:customer_id,:moneda_id,:fecha)
    return @facturas
    
 end 
 
 def get_pendientes_day_value(fecha1,fecha2,value = "balance",moneda)

    facturas = Factura.where(["balance>0  and  company_id = ? AND fecha >= ? and fecha<= ? and moneda_id = ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda ]).order(:customer_id,:moneda_id)
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

 def get_facturas_day_cliente(fecha1,fecha2,cliente)

    @facturas = Factura.where(["total> 0  and  company_id = ? AND fecha >= ? and fecha<= ? and customer_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", cliente ]).order(:customer_id,:moneda_id,:fecha)
    return @facturas
    
 end 
 

 def get_pendientes_day_cliente(fecha1,fecha2,cliente)

    @facturas = Factura.where(["balance > 0  and  company_id = ? AND fecha >= ? and fecha<= ? and customer_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", cliente ]).order(:customer_id,:moneda_id,:fecha)
    return @facturas
    
 end 
 
 def get_pendientes_day_cliente_value(fecha1,fecha2,value = "total",moneda,cliente)

    facturas = Factura.where(["balance>0  and  company_id = ? AND fecha >= ? and fecha<= ? and moneda_id = ? and customer_id = ?", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", moneda , cliente ]).order(:customer_id,:moneda_id)
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
 
 def get_pendientes_day_customer(fecha1,fecha2,value,moneda)

    facturas = Factura.where(["balance>0  and  company_id = ? AND fecha >= ? and fecha<= ? AND customer_id = ? and moneda_id =  ? ", self.id, "#{fecha1} 00:00:00","#{fecha2} 23:59:59", value , moneda ]).order(:customer_id,:moneda_id)

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
    products = Product.where(company_id: self.id)
    
    return products
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
    customers = Customer.where(company_id: self.id).order(:name)

    return customers
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
end