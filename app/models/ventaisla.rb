
class Ventaisla < ActiveRecord::Base
    
        require "open-uri"  
    validates_presence_of :employee_id
    
    
    belongs_to :employee 
    belongs_to :island  
    
    has_many :ventaisla_details, :dependent => :destroy
    
  
    
    belongs_to :payroll 
    
    def self.import2(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Ventaisla.create! row.to_hash 
          
        end
    end         
   
    def self.import4(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          VentaislaDetail.create! row.to_hash 
          
        end
    end    
    
    def self.import3(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
              
              
              
          
           @pump_isla = Pump.find_by(fuel: row['manguera'])
           
           start_date = row['fecha'].to_date.strftime("%Y-%m-%d") + " 00:00:00"
           end_date = row['fecha'].to_date.strftime("%Y-%m-%d") + " 23:59:00"
           turnox = row['turno']
           lectura_ant =  row['inicial']
           lectura_act =  row['final']
           precio  =  row['precio']
           cantidad = row['cantidad']
           importe = row['importe']
           empleado = row['employee_id']
           puts start_date
           
          
            @venta_isla_id = Ventaisla.find_by("(fecha >= ?) AND (fecha <= ?) and turno = ?  and employee_id = ?  and island_id = ?", start_date , end_date , turnox,empleado, "1")
            
            
             if @venta_isla_id 
                
                xpump_id =  Pump.find_by(fuel: row['manguera'])
                
                if xpump_id
                puts "venta isla detalle pump  "
                    
                @ventaisla_detail = VentaislaDetail.new(pump_id: xpump_id.id , le_an_gln: lectura_ant,le_ac_gln: lectura_act,price:precio, quantity: cantidad ,total: importe ,ventaisla_id: @venta_isla_id.id , product_id: @pump_isla.product_id )
                @ventaisla_detail.save
                
                end 
                
            end     
              
          
          
        end
    end         
    
    def get_importe_1(value="total")
        
        facturas = VentaislaDetail.where(["ventaisla_id = ? ", self.id ])
        ret=0  
        
        for factura in facturas
            if(value == "total")
              ret += factura.total
            end 
            if(value == "galones")
              ret += factura.quantity
            end
            
        end    

        return ret
        
    end 
def  get_ventas_combustibles_producto(isla,producto,value) 
    
    ret=0  
    
    
     facturas = VentaislaDetail.where(["ventaisla_id = ? and product_id = ?",isla,producto])
    
    if facturas
    ret=0  
    for factura in facturas
      if value == "qty"
        ret+= factura.quantity * -1
      else
        ret += factura.total * -1 
    
      end
    end
    
    end 

    return ret
  
    
    return facturas
    
 end 
 
 
    TURNO1  = ["06:00:00", "13:59:59"]
    TURNO2  = ["14:00:00", "21:59:59"]
    TURNO30 = ["22:00:00", "23:59:59"]
    
    TURNO31 = ["00:00:00", "05:59:59"]
    
       
    
    def self.turno2( date )
          date_str = date.strftime( "%H:%M:%S" )
          turno = "1"
          
      if   date_str >= TURNO1[0] and date_str <= TURNO1[1]
          turno = "1"
      end
      if   date_str >= TURNO2[0] and date_str <= TURNO2[1]
          turno = "2"
      end
      if   date_str >= TURNO30[0] and date_str <= TURNO30[1]
          turno = "3"
      end
      
      if   date_str >= TURNO31[0] and date_str <= TURNO31[1]
          turno = "3"
      end
      
      return turno 
    end
    

    def self.get_surtidor(surtidor,lado_surtidor,id_producto,posicion_manguera)
        if id_producto == 7
            id_producto = 6  
        end
        a =Pump.find_by(id_surtidor: surtidor,product_id: id_producto, id_posicion_manguera: posicion_manguera)
        
        if a 
            return a.id
            
        else
            return  1 
        end
        
    end 
 
  def self.import(file)
        cantidad_total = 0
        importe_total = 0 
        
          @islas = Island.all 
          Journal.delete_all 
          
            CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
                    f1 = row['ffecha_journal'] 
                 
                    
                    row['turno']     = self.turno2(f1.to_datetime)
                    
                    date_str = f1.to_datetime.strftime( "%H:%M:%S" )
                    
                    if   date_str >= TURNO31[0] and date_str <= TURNO31[1]
                        
                           puts     row['ffecha_journal']
                           puts     row['ffechacontable_journal']
                    
                          fecha_hoy = row['ffecha_journal'].to_date - 1  
                          row['ffecha_journal'] = fecha_hoy
                          
                    else
                          row['ffecha_journal'] = f1.to_date 
                    end
                    
                    
                    
                    Journal.create! row.to_hash 
            
          end   
          
            
          @journal = Journal.all 
          
         CSV.open("file.csv", "wb") do |csv|
            csv << Journal.attribute_names
            Journal.all.each do |user|
                csv << user.attributes.values
            end
        end
        
        
        
        
          fecha_venta_isla = @journal.last.ffecha_journal
          
          (1..3).map do |turnos|
              
           for isla in @islas 
                isla_existe = Ventaisla.find_by(island_id: isla.id , turno: turnos , employee_id: 1,fecha: fecha_venta_isla)  
                puts "isla "
                puts isla.id
                puts turnos 
                puts fecha_venta_isla 
                
                 if isla_existe 
                     
                 else 
                  @ventaisla = Ventaisla.new(fecha: fecha_venta_isla, turno: turnos ,employee_id: 1, importe: 0,galones: 0 ,island_id: isla.id )               
                  @ventaisla.save
                 end 
            end
         end 
         
          @journal  = Journal.select("to_char(ffecha_journal,'dd/MM/yyyy') as ffecha_journal_date ,nid_surtidor,nposicion_manguera,dprecio_journal,turno, MAX(dcontometrogalon_journal) as dcontometrogalon_journal,sum(dvolumen_journal) as dvolumen_journal,sum(dmonto_journal) as dmonto_journal ").group("ffecha_journal_date " ,:turno,:nid_surtidor,:nposicion_manguera,:dprecio_journal)
        
          
          for journal in @journal
          fecha_venta_isla =  journal.ffecha_journal_date.to_date  
          lectura_ant = journal.dcontometrogalon_journal.to_f - journal.dvolumen_journal.to_f
          lectura_act = journal.dcontometrogalon_journal.to_f
          precio      = journal.dprecio_journal.to_f
          cantidad    = journal.dvolumen_journal.to_f
          importe     =  journal.dmonto_journal.to_f
          a           = journal.turno 
          
            cantidad_total += cantidad
            importe_total += importe 
            start_date = fecha_venta_isla.strftime("%Y-%m-%d") + " 00:00:00"
            end_date  = fecha_venta_isla.strftime("%Y-%m-%d") + " 23:59:59"
            
             puts "venta isla detalle "
                puts "id surtidor"
                puts journal.nid_surtidor
                puts "id manguera"
                puts journal.nposicion_manguera
                
                
            @pump_isla = Pump.find_by(id_surtidor: journal.nid_surtidor,id_posicion_manguera: journal.nposicion_manguera)
                  
            @venta_isla_id = Ventaisla.find_by("(fecha >= ?) AND (fecha <= ?) and turno = ?  and employee_id = 1  and island_id = ?", start_date , end_date , a, @pump_isla.island_id)
            
            
             if @venta_isla_id 
                
                xpump_id = Pump.find_by(id_surtidor: journal.nid_surtidor,id_posicion_manguera: journal.nposicion_manguera)
                
                if xpump_id
                puts "venta isla detalle pump  "
                    
                @ventaisla_detail = VentaislaDetail.new(pump_id: xpump_id.id , le_an_gln: lectura_ant,le_ac_gln: lectura_act,price:precio, quantity: cantidad ,total: importe ,ventaisla_id: @venta_isla_id.id , product_id: @pump_isla.product_id )
                @ventaisla_detail.save
                
                end 
                
            end 
           
            end 
            
        
                @isladetalle = Ventaisla.where(["fecha >= ? and fecha <= ?","#{fecha_venta_isla} 00:00:00","#{fecha_venta_isla} 23:59:59"])
                puts "fecha venta isla "
                puts fecha_venta_isla
                
                
                for a in @isladetalle                   
                
                total_glns    = a.get_venta_total_glns(a.turno, a.island_id)
                total_importe = a.get_venta_total_impo(a.turno, a.island_id)
                
                 
                 a.galones = total_glns
                 a.importe = total_importe
                 a.save 
                 
               end 
                 
        end
    
    
def get_venta_total_glns(turno1,isla)
     facturas = VentaislaDetail.where([" ventaisla_id = ?", self.id ]).order(:id)
          ret = 0 
          if facturas 
          ret=0  
            for factura in facturas      
                ret += factura.quantity
            end
          end 
          return ret    
     
end 
        def get_venta_total_impo(turno1,isla)
            facturas = VentaislaDetail.where(["ventaisla_id = ?",self.id ]).order(:id)
             ret = 0 
            if facturas 
            ret=0  
            for factura in facturas      
                ret += factura.total
            end
            end 
            return ret    
        end 

        def  get_ventas_grifero_turno(fecha1,fecha2,grifero,turno) 
            facturas = Ventaisla.where(["fecha >= ?  and fecha <=  ? and employee_id = ? and turno = ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"   , grifero,turno] ).order(:fecha,:turno)
            return facturas 
        end 
        
        
        def  get_tirada_grifero_turno(fecha1,fecha2,grifero,turno) 
            ret = 0
            facturas = Tirad.where(["fecha >= ?  and fecha <=  ? and employee_id = ? and turno = ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"   , grifero,turno] ).order(:fecha,:turno)
            for factura in facturas
                ret += factura.importe.to_f
            end
            return ret
       
        end 
        def  get_ventaplaya_grifero_turno(fecha1,fecha2,grifero,turno) 
            ret = 0
            facturas = Sellvale.where(["fecha >= ?  and fecha <=  ? and cod_emp = ? and turno = ?  " , "#{fecha1} 00:00:00","#{fecha2} 23:59:59" , grifero,turno ]).order(:fecha,:turno)
            for factura in facturas
                ret += factura.importe.to_f
            end
            return ret
        end 
        
      
      
      ####
      def  get_ventas_contometros_efectivo_grifero_turno(fecha,grifero,turno) 

             facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago = ? and td <> ?  and tipo<> ? and cod_emp = ? and turno=? " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N","2",grifero,turno])
             
             if facturas
                 
                ret=0  
                for detalle in facturas
                    ret += detalle.importe.to_f
               end 
            end 
        
            return ret
         
        end
        
      
        
        
        def  get_ventas_contometros_tarjeta_grifero_turno(fecha,grifero,turno) 

             facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and fpago <> ?  and td <> ?  and tipo = ? and cod_emp = ? and turno=?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "1" ,"N","1",grifero,turno])
             
             if facturas
                 
                ret=0  
                for detalle in facturas
                    ret += detalle.importe.to_f
               end 
            end 
        
            return ret
         
         end 
        
         def  get_ventas_contometros_creditos_grifero_turno(fecha,grifero,turno ) 
     
           facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
             INNER JOIN products ON sellvales.cod_prod = products.code 
             WHERE products.products_category_id = 1 
             and sellvales.fecha >= ? 
             and sellvales.fecha <= ? 
             and td = ? and tipo = ? and cod_emp = ? and turno = ? 
             ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ,grifero,turno])
             
          #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
             
             if facturas
                 
                ret=0  
                for detalle in facturas
                    ret += detalle.implista
               end 
            end 
        
            return ret
         
         end 
 
         
         def  get_ventas_lubricantes_creditos_grifero_turno(fecha,grifero,turno ) 
     
           facturas = Sellvale.find_by_sql(['Select sellvales.* from sellvales    
             INNER JOIN products ON sellvales.cod_prod = products.code 
             WHERE products.products_category_id = 2 
             and sellvales.fecha >= ? 
             and sellvales.fecha <= ? 
             and cod_emp = ? and turno = ? 
             ORDER BY sellvales.fecha', "#{fecha} 00:00:00","#{fecha} 23:59:59",grifero,turno])
             
          #facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","1" ])
             
             if facturas
                 
                ret=0  
                for detalle in facturas
                    ret += detalle.implista
               end 
            end 
        
            return ret
         
         end 
         
         
         def  get_ventas_contometros_adelantado_grifero_turno(fecha,grifero,turno ) 
        
             facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ?  and tipo = ? and cod_emp = ? and turno = ?" , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","4",grifero,turno ])
             
             if facturas
                 
                ret=0  
                for detalle in facturas
                     ret += detalle.implista
               end 
            end 
        
            return ret
         
         end 
 
 
         def  get_ventas_vale_contado_grifero_turno(fecha,grifero,turno ) 
        
             facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and td = ? and tipo  = ? and cod_emp = ? and turno = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59", "N","2",grifero,turno ])
             ret=0  
             if facturas
                 
                
                for detalle in facturas
                     ret += detalle.importe.to_f
                
               end 
            end 
        
            return ret
         
         end 
         
         
          def  get_ventas_tirada_grifero_turno(fecha,grifero,turno ) 
        
             facturas = Tirad.where(["fecha >= ? and fecha <= ?  and employee_id = ? and turno = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",grifero,turno ])
             ret=0  
             if facturas
                 
                
                for detalle in facturas
                     ret += detalle.importe.to_f
                
               end 
            end 
        
            return ret
         end 
      
      ####
      
        
        
        def  get_ventaplaya_grifero_turno_documento(fecha1,grifero,turno,value="F") 
          
             ret = 0
             
          facturas = Sellvale.where(["fecha >= ?  and fecha <=  ? and cod_emp = ? and turno = ?   and fpago <> ?" , "#{fecha1} 00:00:00","#{fecha1} 23:59:59"  , grifero,turno ,"1"] ).order(:fecha,:turno)
          for factura in facturas
            if (value == "F")
              ret += factura.importe.to_f
            elsif(value == "B")
              ret += factura.importe.to_f
            else
              ret += factura.importe.to_f
            end
          end
          
          return ret
             
        end 
        
        def get_product(id)        
            
            a = Product.find(id)
            return a.full_name
            
            
        end 
        
          
        def get_product2(id)        
            
            a = Product.find_by(code: id)
            return a.full_name
            
            
        end 
        
        
        def get_code(id)    
            a= Employee.find(id)    
            if a 
            return a.cod_emp 
            else
            return "0001"
            end 
        end 
        


end
