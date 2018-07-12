class Expense < ActiveRecord::Base
    
  validates_presence_of   :code,:fecha,:gasto_id,:documento,:descrip
  
  validates :importe,    :numericality => true

  validates_uniqueness_of :code
  
  
  
    
  def correlativo      
        numero = Voided.find(18).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'18').update_all(:numero =>lcnumero)        
  end


end
