class Assistance < ActiveRecord::Base

    belongs_to :inasist
    
    belongs_to :company

    belongs_to :employee
  
    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          
          puts "fecha ==> "
          puts row['fecha']
            Assistance.create! row.to_hash 

        end
    end     


 # Process the invoice
  def process(fecha)
     rango_fecha = "2019-12-01 00:00:00"


      planilla  =Employee.where("planilla = ? ","1")

      fecha_dic="2019-12-01 00:00:00"

        Assistance.where(fecha)    

        fecha_asistencia = fecha 

        Assistance.where("fecha >= ? and fecha <= ?", "#{fecha_asistencia} 00:00:00","#{fecha_asistencia} 23:59:59 ").delete_all 
        
        for ip in planilla
        

           hora10 = fecha_asistencia.in_time_zone.change( hour: 8) 
           hora20 = fecha_asistencia.in_time_zone.change( hour: 17 , min: 45 )
           hora30 = fecha_asistencia.in_time_zone.change( hour: 18 ,  min: 30 )



            a=  Assistance.new(departamento: "", nombre:"", employee_id: ip.id  , fecha:  fecha_asistencia, equipo:"", cod_verificacion: "",
              num_tarjeta:"",hora1: hora10 ,hora2: hora20, hora_efectivo: hora10 ,  hora_efectivo2: hora30 ,  inasist_id: "1" )
            a.save

            self.save


    
        end 

        #actualiza vacaciones 
        # puts "fecha Assistancia"
        # puts fecha_asistencia
        # fecha_inicial = "{fecha_asistencia} 00:00:00"
        # fecha_final =  "{fecha_asistencia} 23:59:59"


        # @vacaciones  =  Vacation.where("fecha1 >= ? and fecha2 <= ?", "#{fecha_asistencia} 00:00:00","#{fecha_asistencia} 23:59:59")
      
        # for vacacion in @vacaciones 

        #    Assistance.update_attribute(inasist_id:  3 ).where(" employee_id  =?  and fecha >=? and fecha <=? ",vacacion.employee_id, "#{vacacion.fecha1}  00:00:00","#{vacacion.fecha2} 23:59:59 ")  
        #     puts "actualizacion..."
        #     puts vacacion.employee_id

        # end 



  end 


  def time_diff(start_time, end_time)

    
  seconds_diff = (start_time - end_time).to_i.abs

  hours = seconds_diff / 3600
  seconds_diff -= hours * 3600

  minutes = seconds_diff / 60 
  seconds_diff -= minutes * 60

  seconds = seconds_diff

  return "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  # or, as hagello suggested in the comments:
  # '%02d:%02d:%02d' % [hours, minutes, seconds]
  end


    # def self.search(search, id)
    #  if search
    #    where(['idnumber iLIKE ? and AND fecha >= ? and fecha<= ? ', "%#{search}%" ,  "#{fecha} 00:00:00","#{fecha} 23:59:59"])
    #  else
    #   scoped
    #  end
    # end

    def self_searched_fields

      sharks = ["employee_id", "fecha", "fecha"]
      return sharks

    end 

    def self.search(fecha1,fecha2,empleado)

      if empleado == "0"
        self.where(['fecha >= ? and fecha<= ? ', "#{fecha1} ","#{fecha2} "])

      else 
        self.where(['fecha >= ? and fecha<= ? and employee_id = ?', "%#{search}%" ,  "#{fecha}","#{fecha} ",empleado])

      end 


    end                     

end
