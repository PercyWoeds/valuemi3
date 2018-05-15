class VentaProducto < ActiveRecord::Base
    
  validates_presence_of :documento, :code,:fecha

  validates_uniqueness_of :code
  
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :user
  belongs_to :document
  belongs_to :tarjetum  
    
    def correlativo
        
        numero = Voided.find(17).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'17').update_all(:numero =>lcnumero)        
  end
end
