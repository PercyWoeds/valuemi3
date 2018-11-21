class Ventaisla < ActiveRecord::Base
      
    validates_presence_of :employee_id
    
    
    belongs_to :employee 
    belongs_to :island  
    
    has_many :ventaisla_details, :dependent => :destroy
    
    
    
    belongs_to :payroll 
    
       
    
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
            
            Journal.create! row.to_hash 
            
          end   
            
          @journal = Journal.all 
          fecha_venta_isla = @journal.first.ffecha_journal
          
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
         
          @journal  = Journal.select("ffecha_journal,nid_surtidor,nposicion_manguera,dprecio_journal, MAX(dcontometrogalon_journal) as dcontometrogalon_journal,sum(dvolumen_journal) as dvolumen_journal,sum(dmonto_journal) as dmonto_journal ").group(:ffecha_journal,:nid_surtidor,:nposicion_manguera,:dprecio_journal)
        
          
          for journal in @journal
          
          f1 = journal.ffecha_journal
          fecha_venta_isla = f1.to_date 
          
          a           = self.turno2(f1.to_datetime)
          lectura_ant = journal.dcontometrogalon_journal.to_f - journal.dvolumen_journal.to_f
          lectura_act = journal.dcontometrogalon_journal.to_f
          precio      = journal.dprecio_journal.to_f
          cantidad    = journal.dvolumen_journal.to_f
          importe     =  journal.dmonto_journal.to_f
          
          
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
                
                 isla = Ventaisla.find(a.island_id)
                 isla.galones = total_glns
                 isla.importe = total_importe
                 isla.save 
               end 
                 
        end
    
    
def get_venta_total_glns(turno1,isla)
     facturas = VentaislaDetail.where([" island_id = ?", self.id ]).order(:id)
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
     facturas = VentaislaDetail.where(["island_id = ?",self.id ]).order(:id)
          ret = 0 
          if facturas 
          ret=0  
            for factura in facturas      
                ret += factura.total
            end
          end 
          return ret    
end 

end
