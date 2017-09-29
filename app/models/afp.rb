class Afp < ActiveRecord::Base
    
    validates_presence_of :name 
    
    has_many :parameter_details
    
end
