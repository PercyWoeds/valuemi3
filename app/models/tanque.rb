class Tanque < ActiveRecord::Base
    validates_uniqueness_of :code
    validates_presence_of :code,:product_id,:saldo_inicial,:varilla 
    
    belongs_to :product 
    has_many :afericions  
    
end
