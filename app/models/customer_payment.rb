class CustomerPayment < ActiveRecord::Base
self.per_page = 20
   
  validates_presence_of :company_id, :total,:user_id
  
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

 def get_customer_payment_value(value)
    invoices = CustomerPaymentDetail.where(["customer_payment_id = ?", self.id])
    ret = 0
    
    for invoice in invoices
      if(value == "subtotal")
        ret = 0 
      else
        ret += invoice.factory
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
        factory = parts[1]
        balance = parts[2]
                  
        
        begin
          factura = Factura.find(id.to_i)          

          new_factura = CustomerPaymentDetail.new(:customer_payment_id => self.id, 
                                  :factura_id => factura.id, :factory => factory,:total => balance.to_f )
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
          @newbalance = @last_balance - balance.to_f.round(2) - factory.to_f.round(2) 
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
      facturas.code,facturas.customer_id,facturas.fecha,customer_payment_details.factory from customer_payment_details   
      INNER JOIN facturas ON   customer_payment_details.factura_id = facturas.id
      WHERE  customer_payment_details.customer_payment_id = ?', self.id ])

    return @itemproducts
  end
  
  def get_payments_customer
    invoice_products = CustomerPaymentDetail.where(customer_payment_id:  self.id)                                                                                                                                                                                                                                                                                        
    return invoice_products
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


