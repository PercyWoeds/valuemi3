class Afp < ActiveRecord::Base
    
    validates_presence_of :name 
    belongs_to :employee
     
    has_many :parameter_details
    
end
