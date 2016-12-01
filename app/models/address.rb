class Address < ActiveRecord::Base
		validates_presence_of  :address 
  
  belongs_to :company 	 
  belongs_to :customer 
  belongs_to :user
 
end
