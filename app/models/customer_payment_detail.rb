class CustomerPaymentDetail < ActiveRecord::Base

 validates_presence_of :customer_payment_id, :factura_id, :total

  
  belongs_to :customer_payment_details	
  belongs_to :factura 
  belongs_to :document
  belongs_to :customer 
    

  def get_customer(id)
    a = Customer.find(id)
    return a.name 
  end 


  def get_customer_ruc(id)    
    a = Customer.find(id)
    return a.ruc  
  end 
  
  def get_document(id)
    a =Document.find(id)
    return a.description

  end 
  
end



