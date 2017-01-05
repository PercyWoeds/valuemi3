class Quotation < ActiveRecord::Base

def correlativo
        
        numero = Voided.find(9).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'9').update_all(:numero =>lcnumero)        
  end




end
