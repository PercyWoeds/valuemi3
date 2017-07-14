class LgvDelivery < ActiveRecord::Base
    validates_presence_of :lgv_id, :compro_id,  :importe 
  
    belongs_to :lgv 
    belongs_to :compro
end
