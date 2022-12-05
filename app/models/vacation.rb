class Vacation < ActiveRecord::Base


	    belongs_to :employee

	

	validates_presence_of :fecha1,:fecha2 ,:employee_id 
	    
end
