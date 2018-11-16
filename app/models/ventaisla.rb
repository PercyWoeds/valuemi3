class Ventaisla < ActiveRecord::Base
      
    validates_presence_of :employee_id
    
    
    belongs_to :employee 
    
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
    
       
    
    def self.turno( date )
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
    
          @islas = Island.all 
          Journal.delete_all 
          
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
            
            Journal.create! row.to_hash 
            
          end   
            
          @journal = Journal.all 
          
          
          for journal in @journal
          
          f1 = row['ffecha_journal']
          fecha_venta_isla = f1.to_date 
          
          a           = self.turno(f1.to_datetime)
          pump_id     = self.get_surtidor(row['nid_surtidor'].to_i,row['nlado_surtidor'].to_i,row['nid_producto'].to_i,row['nposicion_manguera'].to_i)
          lectura_ant = row['dcontometrogalon_journal'].to_f - row['dvolumen_journal'].to_f
          lectura_act = row['dcontometrogalon_journal'].to_f
          precio      = row['dprecio_journal'].to_f
          cantidad    = row['dvolumen_journal'].to_f
          importe     =  row['dmonto_journal'].to_f
          
           if   row['dmonto_journal'].to_i == 7        
              producto = "5"
            else
              producto = row['dmonto_journal'].to_i
           end 
            
           for isla in @islas 
                isla_existe = Ventaisla.find_by(id: isla.id , turno: a , employee_id: 1,fecha: fecha_venta_isla)  
                puts "isla "
                puts isla.id
                puts a 
                puts fecha_venta_isla 
                
                 if isla_existe 
                 else 
                  @ventaisla = Ventaisla.new(fecha: fecha_venta_isla, turno: a ,employee_id: 1, importe: 0,galones: 0  )               
                  @ventaisla.save
                 end 
            end
            
            @venta_isla_id = Ventaisla.find_by(fecha: fecha_venta_isla, turno: a ,employee_id: 1)      
            
            if @venta_isla_id 
                @ventaisla_detail = VentaislaDetail.new(pumpid: pump_id, le_an_gln: lectura_ant,lectura_act: lectura_act,price:precio, quantity: cantidad ,total: importe ,ventaisla_id: @venta_isla_id.id , product_id: producto )
                @ventaisla_detail.save
            end 
           end 
            
          
          
        end
    
    

end
