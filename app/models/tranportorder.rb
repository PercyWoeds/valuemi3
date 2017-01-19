class Tranportorder < ActiveRecord::Base

	validates_presence_of :fecha1,:fecha2

	belongs_to :company
  	belongs_to :location
  	belongs_to :division 
  	belongs_to :user
  
	belongs_to :customer
	belongs_to :employee
	belongs_to :punto 
	belongs_to :truck

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

end
