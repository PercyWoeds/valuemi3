class CustomerPayment < ActiveRecord::Base
self.per_page = 20
   
  validates_presence_of :company_id, :total,:user_id,:fecha1 
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :customer 
  belongs_to :user
  belongs_to :payment
  belongs_to :bank_acount

  has_many :customer_payment_details
  
  TABLE_HEADERS = ["ITEM",
                     "TIPO",
                     "DOCUMENTO",
                     "CLIENTE ",                     
                     "FACTORY",
                     "IMPORTE  "]
  
  TABLE_HEADERS1 = ["ITEM",
                     "FECHA",
                     "RECEP.",
                     "VENCE",
                     "",
                     "",
                     "DOCUMENTO",
                     "PROVEEDOR",
                     "IMPORTE  ",
                     "CARGOS  ",
                     "PAGOS  ",
                      "SALDO  "]

  TABLE_HEADERS2 = ["ITEM",
                     "FECHA",
                     "RECEP.",
                     "VENCE",
                     "",
                     "",
                     "DOCUMENTO",
                     "PROVEEDOR",
                     "IMPORTE  ",
                     "CARGOS  ",
                     "PAGOS  ",
                      "SALDO  "]

  TABLE_HEADERS3 = ["ITEM",
                     "NRO.",
                     "FECHA",
                     "CUENTA",
                     "FECHA ",
                     "RUC",
                     "CLIENTE
                     ",
                     "",                    
                     "FACTORY  ",
                     "IMPORTE  "]                      


  TABLE_HEADERS4 = ["ITEM",
                     "CLIENTE",                     
                    "IMPORTE "]                      

  TABLE_HEADERS5 = ["ITEM ",
                     "BANCO ",                  
                    "IMPORTE "]                      

  TABLE_HEADERS6 = ["ITEM",
                     "CLIENTE",   
                     "=<2016",                  
                    "Ene-2017",
                    "Feb-2017",             
                    "Mar-2017",
                    "Abr-2017",
                    "May-2017",
                    "Jun-2017",
                    "Jul-201",             
                    "Ago-2017",
                    "Sep-2017",
                    "Oct-2017",
                    "Nov-2017",              
                    "Dic-2017",
                    "TOTAL   "]


 def get_document_short(id)

     documento = Document.find(id)
     return documento.descripshort 
 end                      
 def get_customer_payment_value(value)
    invoices = CustomerPaymentDetail.where(["customer_payment_id = ?", self.id])
    ret = 0
    
    for invoice in invoices

      if(value == "factory")
        ret += invoice.factory
      elsif (value == "compen")        
        ret += invoice.compen    
      elsif (value == "total")        
        ret += invoice.total

      else
        ret += invoice.ajuste
      end
    end
    
    return ret
  end


  def correlativo
        
        numero = Voided.find(10).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'10').update_all(:numero =>lcnumero)        
  end
          
            
  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        
        price = parts[1]
      
        
        total = price.to_f.round(2) 
        
        
        begin
          product = Factura.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  
  def delete_products()
    invoice_products = CustomerPaymentDetail.where(customer_payment_id: self.id)
    
    for ip in invoice_products

        id = ip.id
        balance = ip.total
                  
        
        begin
          factura = Factura.find(id.to_i)          


          if factura.payment == nil
             factura.payment =0 
          end 
          if factura.balance == nil
             factura.balance =0 
          end 


          @last_payment = factura.payment - balance.round(2) 
          @last_balance = factura.balance 
          @newbalance = @last_balance + balance.round(2) 
          factura.update_attributes(payment: @last_payment,balance: @newbalance )  
          
        end

      ip.destroy


    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        compen  = parts[1]
        ajuste  = parts[2]
        factory = parts[3]
        balance = parts[4]
                  
        
        begin
          factura = Factura.find(id.to_i)          

          new_factura = CustomerPaymentDetail.new(:customer_payment_id => self.id,:compen=> compen.to_f,:ajuste => ajuste.to_f, 
                                  :factura_id => factura.id, :factory => factory.to_f,:total => balance.to_f )
          new_factura.save

          if factura.charge== nil
             factura.charge =0 
          end 
          if factura.balance == nil
             factura.balance =0 
          end 

          if factura.pago == nil
             factura.pago = 0 
          end 
         
          @last_payment = factura.pago + factura.balance.to_f.round(2) 
          @last_balance = factura.balance 
          @newbalance = @last_balance - balance.to_f.round(2) + ajuste.to_f.round(2)

          factura.update_attributes(pago: @last_payment,balance: @newbalance )  
          
        end
      end
    end
  end
  
  def get_banco(id)
    a = Bank.find(id)

    return a.name 
  end
  def get_moneda(id)
    a = Moneda.find(id)

    return a.description
  end

  def get_customer(id)

    a = Customer.find(id)
    return a.name 

  end 
  def get_document(id)

    a = Document.find(id)
    return a.description 

  end 
  
  def identifier
    return "#{self.code} - #{self.bank_acount.number}"
  end

  def get_payments    
 @itemproducts = CustomerPaymentDetail.find_by_sql(['Select customer_payment_details.total,
      facturas.code,facturas.customer_id,facturas.fecha,customer_payment_details.factory,customer_payment_details.ajuste from customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      WHERE  customer_payment_details.customer_payment_id = ?', self.id ])

    return @itemproducts
  end


  def get_payment_dato(id)    

 @itemproducts = CustomerPaymentDetail.find_by_sql(['Select customer_payment_details.total,
      facturas.code,facturas.customer_id,facturas.fecha,customer_payment_details.factory,customer_payment_details.ajuste,
      customer_payment_details.compen,facturas.tipo  from customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      WHERE  customer_payment_details.customer_payment_id = ?', id ])

    return @itemproducts
  end
  
  
  
  def products_lines
    facturas = []
    invoice_products = CustomerPaymentDetail.where(customer_payment_id:  self.id)
    
    invoice_products.each do | ip |
                                                                                                                                                                                                                                                                                                              
      ip.facturas[:balance] = ip.total 
      
      facturas.push("#{ip.factura.id}|BRK#{ip.factura.total}")
    end

    return products.join(",")
  end
  
  def get_processed
    if(self.processed == "1")
      return "Procesado"
    else
      return "No procesado"
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
      return "Si"
    else
      return "No"
    end
  end
  
  def get_return
    if(self.return == "1")
      return "Si"
    else
      return "No"
    end
  end
  
  # Process the invoice
  def process

    if(self.processed == "1" or self.processed == true)
      invoice_products = CustomerPaymentDetail.where(customer_payment_id: self.id)
    
      
      self.date_processed = Time.now
      self.save
    end
  end
  
  # Color for processed or not
  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end
end


