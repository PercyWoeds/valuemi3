class Employee < ActiveRecord::Base

	before_save :set_full_name
	
	has_many :outputs
	has_many :payroll_details
	has_many :payrollbonis 
	
    validates_uniqueness_of :idnumber
    validates_presence_of :company_id, :idnumber, :firstname,:lastname,:fecha_ingreso,:fecha_nacimiento
 
	def get_afp(parameter_id,comision_id,value = "aporte")
	
	 detalle = ParameterDetail.where(["afp_id = ? and comision_id = ?  and parameter_id = ?", self.afp_id, self.comision_id, parameter_id ])
    if detalle
    ret=0  
    for dato in detalle
        if value="aporte"
            ret = dato.aporte 
        end
        
        if value="seguro"
            ret = dato.seguro
        end
        if value="comision"
            if comision_id = 1 
            ret = dato.comision_flujo
            end 
            if comision_id = 2
            ret = dato.comision_mixta
            end 
            if comision_id = 3
            ret = dato.comision_mixta_saldo
            end 
            
        end
        
    end
    end 

    return ret
		
	end 

	private 

	def set_full_name
		self.full_name ="#{self.firstname} #{self.lastname}".strip		

	end 
	
	def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Employee.create! row.to_hash 
        end
    end       
    

end
