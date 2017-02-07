class SupplierPayment < ActiveRecord::Base
self.per_page = 20
   
  validates_presence_of :company_id, :total,:user_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier 
  belongs_to :user
  belongs_to :payment
  belongs_to :bank_acount

  has_many :supplier_payment_details
  
  TABLE_HEADERS = ["ITEM",
                     "TIPO",
                     "DOCUMENTO",
                     "PROVEEDOR",
                     "OPERACION",
                     "IMPORTE  "]
  
  TABLE_HEADERS1 = ["ITEM",
                     "FECHA",
                     "RECEP.",
                     "VENCE",
                     "",
                     "",
                     "DOCUMENTO",
                     "PROVEEDOR",
                     "IMPORTE  " ]



  TABLE_HEADERS2 = ["ITEM",
                     "NRO.",
                     "FECHA",
                     "TD",
                     "DOC.",
                     "FEC.DOC.",
                     "RUC",
                     "CLIENTE",                    
                     "DEBE  ",
                     "HABER  "]                      


  def correlativo
        
        numero = Voided.find(11).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'11').update_all(:numero =>lcnumero)        
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
          product = Purchase.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  
  def delete_products()
    invoice_products = SupplierPaymentDetail.where(supplier_payment_id: self.id)
    
    for ip in invoice_products

        id = ip.id
        balance = ip.total
                  
        
        begin
          purchase = Purchase.find(id.to_i)          


          if purchase.payment == nil
             purchase.payment =0 
          end 
          if purchase.balance == nil
             purchase.balance =0 
          end 


          @last_payment = purchase.payment - balance.round(2) 
          @last_balance = purchase.balance 
          @newbalance = @last_balance + balance.round(2) 
          purchase.update_attributes(payment: @last_payment,balance: @newbalance )  
          
        end

      ip.destroy


    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        balance = parts[1]
                  
        
        begin
          purchase = Purchase.find(id.to_i)          

new_purchase = SupplierPaymentDetail.new(:supplier_payment_id => self.id, 
  :purchase_id => purchase.id, :total => balance.to_f )
          new_purchase.save

          if purchase.payment == nil
             purchase.payment =0 
          end 
          if purchase.balance == nil
             purchase.balance =0 
          end 


          @last_payment = purchase.pago + balance.to_f.round(2) 
          @last_balance = purchase.balance 
          @newbalance = @last_balance - balance.to_f.round(2) 
          purchase.update_attributes(pago: @last_payment,balance: @newbalance )  
          
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

  def get_supplier(id)

    a =Supplier.find(id)
    return a.name 
  end 
  def get_supplier_ruc(id)

    a =Supplier.find(id)
    return a.ruc 

  end 

  def get_document(id)

    a = Document.find(id)
    return a.description 

  end 
  
  def identifier
    return "#{self.code} - #{self.bank_acount.number}"
  end

  def get_payments    
 @itemproducts =SupplierPaymentDetail.find_by_sql(['Select supplier_payment_details.total,
      purchases.documento,purchases.document_id,purchases.supplier_id  from supplier_payment_details   
      INNER JOIN purchases ON   supplier_payment_details.purchase_id = purchases.id
      WHERE  supplier_payment_details.supplier_payment_id = ?', self.id ])

    return @itemproducts
  end
  
  def get_payments_supplier
    invoice_products = SupplierPaymentDetail.where(supplierpayment_id:  self.id)                                                                                                                                                                                                                                                                                        
    return invoice_products
  end
  
  def products_lines
    purchases = []
    invoice_products = SupplierPaymentDetail.where(supplierpayment_id:  self.id)
    
    invoice_products.each do | ip |
                                                                                                                                                                                                                                                                                                              
      ip.purchases[:balance] = ip.total 
      
      purchases.push("#{ip.purchase.id}|BRK#{ip.purchase.total}")
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
      invoice_products = SupplierPaymentDetail.where(supplier_payment_id: self.id)
    
      
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
