class ParameterDetail < ActiveRecord::Base
    
     validates_presence_of :parameter_id, :afp_id, :aporte, :seguro, :comision
     

	belongs_to :parameter
	belongs_to :afp 

end
