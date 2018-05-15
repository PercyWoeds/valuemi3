class Deposito < ActiveRecord::Base
    
    self.per_page = 20
   
  validates_presence_of :company_id, :total,:user_id,:fecha1 ,:bank_acount_id 
  validates_uniqueness_of :code
   belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :customer 
  belongs_to :user
  belongs_to :payment
  belongs_to :bank_acount
  belongs_to :document 
  
  
  
  def correlativo
        
        numero = Voided.find(10).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'16').update_all(:numero =>lcnumero)        
  end
   def process

    if(self.processed == "1" or self.processed == true)
      
      self.date_processed = Time.now
      self.save
    end
  end
  
end
