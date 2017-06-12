class Compro < ActiveRecord::Base
    
    validates_uniqueness_of :numero 
  
  validates_presence_of :company_id, :location_id, :code, :importe,:fecha
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :tranportorder
 
   
 
end
