class Manifest < ActiveRecord::Base

belongs_to :customers 

  def get_customers()
    customers = Customer.all 
    return customers
  end
 def get_puntos()
    puntos = Punto.all 
    return puntos
  end

end
