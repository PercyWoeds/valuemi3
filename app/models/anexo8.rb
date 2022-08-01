class Anexo8 < ActiveRecord::Base

	 validates_presence_of :code,:name ,:tipo
    
     has_many :facturas 
  
end
