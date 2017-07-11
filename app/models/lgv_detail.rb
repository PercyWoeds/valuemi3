class LgvDetail < ActiveRecord::Base
    
    validates_presence_of :lgv_id, :gasto_id,  :total
  
    belongs_to :lgv 
    belongs_to :gasto
end
