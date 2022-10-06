class TmpContometro < ActiveRecord::Base

def actualiza_pump


	@TmpContometro = TmpContometro.where(nid_surtidor:nil, nid_mangueras: nil )

	for detalle in @TmpContometro

      x  = Pump.find_by(id_surtidor: detalle.nid_surtidor, 
      	                id_posicion_manguera: detalle.nid_mangueras)

      detalle.island_id = x.island_id
      detalle.save 
    
    end 

	
    
end

end
