class SupplierPayment < ActiveRecord::Base
self.per_page = 20
   
  validates_presence_of :company_id, :code, :user_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :suppier 
  belongs_to :user
  belongs_to :payment 
  belongs_to :purchase 

  has_many :supplier_payment_details
  
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
    invoice_products = SupplierPaymentDetail.where(supplierpayment_id: self.id)
    
    for ip in invoice_products
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
new_invoice_purchase = SupplierPaymentDetail.new(:supplierpayment_id => self.id, 
  :purchase_id => purchase.id, :total => balance.to_f )
          new_purchase_product.save

          @last_payment = purchase.payment + balance.to_f.round(2) 
          @last_balance = purchase.balance 

          @newbalance = @last_balance - balance.to_f.round(2) 

          purchase.update_attributes(payment: @last_payment,balance: @newbalance )  


        rescue
          
        end
      end
    end
  end
  
  def identifier
    return "#{self.code} - #{self.customer.name}"
  end
  def get_payments    
    @itemproducts =SupplierPaymentDetail.find_by_sql(['Select invoice_products.price,invoice_products.quantity,invoice_products.discount,invoice_products.total,products.name  from invoice_products INNER JOIN products ON invoice_products.product_id = products.id where invoice_products.invoice_id = ?', self.id ])
    puts self.id

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
      invoice_products = SupplierPaymentDetail.where(supplierpayment_id: self.id)
    
      for ip in invoice_products
        product = ip.product
        
        if(product.quantity)
          if(self.return == "0")
            ip.product.quantity -= ip.quantity
          else
            ip.product.quantity += ip.quantity
          end
          ip.product.save
        end
      end
      
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
