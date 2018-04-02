class Afericion < ActiveRecord::Base
    validates_presence_of :quantity,:importe ,:tanque_id 
    
    belongs_to :tanque 
    belongs_to :employee 
    
end
