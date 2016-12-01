class Truck < ActiveRecord::Base


  def get_marcas()
   @marcas = Marca.all
    
    return @marcas
  end  
 def get_modelos()
   @modelos = Modelo.all
    
    return @modelos
  end  

  def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Truck.create! row.to_hash 
        end
  end       
    
end
