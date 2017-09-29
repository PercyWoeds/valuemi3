class Parameter < ActiveRecord::Base
  
  validates_uniqueness_of :code
  validates_presence_of :company_id, :onp , :sctr_1,:sctr_2,:essalud,:user_id,:fecha 
  
  has_many :parameter_details, :dependent => :destroy
  
end
    
