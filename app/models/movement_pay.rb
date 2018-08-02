class MovementPay < ActiveRecord::Base
  
  belongs_to :customer 
    
  def get_product_name(codigo) 
      
      a=Product.find_by(code: codigo)
      
      if a
          
          return a.name 
      else 
          return ".."
          
      end 
      
  end       
  
  def get_document_name(codigo) 
      
      a=Document.find_by(id: codigo)
      
      if a
          
          return a.description 
      else 
          return ".."
          
      end 
      
  end       
  
    
end
