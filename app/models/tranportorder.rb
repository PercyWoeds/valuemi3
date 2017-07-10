class Tranportorder < ActiveRecord::Base
self.per_page = 20

	validates_presence_of :fecha1,:fecha2

	belongs_to :company
  	belongs_to :location
  	belongs_to :division 
  	belongs_to :user  
	belongs_to :customer
	belongs_to :employee
	belongs_to :punto 
	belongs_to :truck
	belongs_to :delivery
	belongs_to :ubication 

 TABLE_HEADERS = ["ITEM",
                     "CODIGO",
                     "EMPLEADO",
                     "PLACA",
                     "DESDE",
                     "HASTA",
                     "FEC.INICIO",
                     "FEC.FIN",                     
                     "ESTADO"]

	def self.search(search)
		  where("code LIKE ?", "%#{search}%") 
  		  
	end


	 def identifier
	    return "#{self.code} - #{self.employee.full_name}"
	 end


	  def get_empleado(id)
	  	if id != nil || id !="" || id.blank? ==false || id.empty? == false 
		  	empleado = Employee.find(id)
		  	return empleado.full_name 	
		else
			return ""  	
	  	end	
	  end 	

	  def get_placa(id)
	  	placa = Truck.find(id)
	  	return placa.placa

	  end 	
	  def get_punto(id)
	  	punto = Punto.find(id)
	  	return punto.name 

	  end 	

	  def get_customers()
	    customers = Customer.all 
	    return customers
	  end

	  def get_puntos()
	    puntos = Punto.all 
	    return puntos
	  end


		def correlativo		
			numero=Voided.find(8).numero.to_i + 1
			lcnumero=numero.to_s
			Voided.where(:id=>'8').update_all(:numero =>lcnumero)        
		end


	  def get_processed
	    if(self.processed == "1")
	      return "Aprobado "
	    elsif (self.processed == "2")      
	      return "**Anulado **"
	    elsif (self.processed == "3")      
	      return "* Cerrado **"
	    elsif (self.processed == "4")        
	      return "* Facturado **"
	    else 
	      return "No Aprobado"
	        
	  end
  end


end
