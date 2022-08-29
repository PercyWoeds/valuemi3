class Contometro < ActiveRecord::Base



  def self.import(file)

        cantidad_total = 0
        importe_total = 0 
        
          @islas = Island.all

          TmpContometro.delete_all 
          
            
        CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          TmpContometro.create! row.to_hash 
          
        end



      @tmp_contometro = TmpContometro.last
      @tmp_contometro.actualiza_pump 

                      
      @tmp_contometro1 =TmpContometro.select("nid_cierreturno,ffechaproceso_cierreturno,sum(dtotgalvendido_manguera) as glns, 
                        sum(d_tot_importe) as total").group(:nid_cierreturno,:ffechaproceso_cierreturno)

      @tmp_contometro2 =TmpContometro.select("nid_cierreturno,sum(dtotgalvendido_manguera) as glns, 
                        sum(d_tot_importe) as total").group(:nid_cierreturno,:nid_surtidor,:nid_mangueras)



        
        for contometro in @tmp_contometro1

  			   isla_existe = Ventaisla.find_by(nro_cierre:  contometro.nid_cierreturno )

  				if isla_existe 
                     
          else
                 

                  @ventaisla = Ventaisla.new(
                  	 fecha: contometro.ffechaproceso_cierreturno,
                  	 turno: 1 ,
                  	 employee_id: 1, 
                  	 importe: contometro.total,
                  	 galones: contometro.glns ,
                     island_id: 1,
                     nro_cierre: contometro.nid_cierreturno ) 

                if   @ventaisla.save

                      @tmp_contometro2 = TmpContometro.where(nid_cierreturno: contometro.nid_cierreturno)



                        for xpump in @tmp_contometro2
                              

                              @pump_isla = Pump.find_by(id_surtidor: xpump.nid_surtidor,
                                                id_posicion_manguera:  xpump.nid_surtidor) 



                              if xpump.nid_producto == 7

                                  @codigo_producto = 6
                              else

                                  @codigo_producto = xpump.nid_producto
                                  
                              end



                             @codigo_producto = xpump  

                             if @pump_isla 

                             @ventaisla_detail = VentaislaDetail.new(
                              pump_id: @pump_isla.id , 
                              le_an_gln: xpump.dcontometroinicial_manguera,
                              le_ac_gln: xpump.dcontometroactual_manguera,
                              price: xpump.dprecio_producto, 
                              quantity: xpump.dtotgalvendido_manguera ,
                              total: xpump.d_tot_importe ,
                              ventaisla_id: @pump_isla.island_id , 
                              product_id: @codigo_producto  )
                              
                               @ventaisla_detail.save
                              end 
                          
                        end


                end 

          end
          end       
        end	  
              
  end



