class TmpFactura < ActiveRecord::Base
    belongs_to :document 
    
    
    def get_importe_soles1
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.subtotal*-1
                    
          else  
                  valor = self.subtotal 
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_soles2
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.tax*-1
                    
          else  
                  valor = self.tax 
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_soles
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.total*-1
                    
          else  
                  valor = self.total 
          
           end   
            
    end
    return valor     
  end 
end
