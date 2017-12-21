class Employee < ActiveRecord::Base

	before_save :set_full_name
	before_save :set_full_name2
	
	belongs_to :location
	belongs_to :division 
	belongs_to :ocupacion
	belongs_to :categorium
	belongs_to :afp 
	
	has_many :outputs
	has_many :payroll_details
	has_many :payrollbonis 
	
	
    validates_uniqueness_of :idnumber
    validates_presence_of :company_id, :idnumber, :firstname,:lastname,:fecha_ingreso,:fecha_nacimiento
 
	def get_afp(parameter_id,value = "aporte")
	
	 detalle = ParameterDetail.where(["afp_id = ? and parameter_id = ?", self.afp_id, parameter_id ])
    if detalle
    ret=0  
      
    for dato in detalle
      
    
       if self.onp == "1"
           ret = 0
       else 
        if (value =="aporte")
            ret = dato.aporte  
        elsif  (value == "seguro")
        
            ret = dato.seguro 
        elsif (value == "comision")
            if self.comision_flujo == 1 
            ret = dato.comision_flujo 
            end 
            if self.comision_flujo == 2
            ret = dato.comision_mixta 
            end 
            if self.comision_flujo == 3
            ret = dato.comision_mixta_saldo 
            end 
            
        end
      end     
    end
    end 

    return ret
		
	end 

	private 

	def set_full_name
		self.full_name ="#{self.firstname} #{self.lastname}".strip		
        self.flujo = 0
	end 
	
	
	def set_full_name2
		self.full_name2 ="#{self.lastname} #{self.firstname}".strip		
        self.flujo = 0
	end 
	
	def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Employee.create! row.to_hash 
        end
    end       
    

end
