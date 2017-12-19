class ParameterDetail < ActiveRecord::Base
    
     validates_presence_of :parameter_id, :afp_id, :aporte, :seguro, :comision_flujo,:comision_mixta,:comision_mixta_saldo
     

	belongs_to :parameter
	belongs_to :afp 

end
