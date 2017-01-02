class SupplierPaymentDetail < ActiveRecord::Base

 validates_presence_of :supplier_payment_id, :purchase_id, :total

  
  belongs_to :supplier_payment_details	
  belongs_to :purchase
   

  def get_supplier(id)
    a =Supplier.find(id)
    return a.name 
  end 

  def get_supplier_ruc(id)    
    a =Supplier.find(id)
    return a.ruc  
  end 
  
  def get_document(id)
    a =Document.find(id)
    return a.description

  end 
  
end
