class Truck < ActiveRecord::Base


  def get_marcas()
   @marcas = Marca.all
    
    return @marcas
  end  
 def get_modelos()
   @modelos = Modelo.all
    
    return @modelos
  end  


end
