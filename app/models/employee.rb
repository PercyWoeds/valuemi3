class Employee < ActiveRecord::Base

	before_save :set_full_name
	
	has_many :outputs
	has_many :payroll_details
	
    validates_uniqueness_of :idnumber
    validates_presence_of :company_id, :idnumber, :firstname,:lastname,:fecha_ingreso,:fecha_nacimiento
 
	def get_afp(parameter_id)
	
	 detalle = ParameterDetail.where(["afp_id = ? and parameter_id = ?", self.afp_id, parameter_id ])
    if detalle
    ret=0  
    for dato in detalle
      
        ret = dato.aporte + dato.seguro + dato.comision 
      
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
