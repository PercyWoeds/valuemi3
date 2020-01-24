class Sellvale < ActiveRecord::Base
 
 validates_presence_of :fecha,:turno,:td,:caja,:serie,:numero,:cod_cli,:placa,:cod_prod,:placa,:cod_prod,:cantidad,:precio,:tipo,:td ,:fpago  
 validates_uniqueness_of :numero, scope: :serie
 
 
 belongs_to :factura_detail
 
 
 TABLE_HEADERS9 = ["ITEM",
                     "PERSONAL",   
                    "01",                  
                    "02",
                    "03",             
                    "04",
                    "05",
                    "06",
                    "07",
                    "08",             
                    "09",
                    "10",
                    "11",
                    "12",              
                    "13",
                    "14",
                    "15",
                    "16",
                    "17",             
                    "18",
                    "19",
                    "20",
                    "21",              
                    "22",
                    "23",
                    "24",             
                    "25",
                    "26",
                    "27",
                    "28",              
                    "29",
                    "30",
                    "31",              
                    
                    "TOTAL   "]
 
    
 def self.import(file)
        TmpFactura.delete_all 
        
       CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
           
           
           row['cod_prod'] =  row['cod_prod'].rjust(2, '0')  
           
           if row['cod_cli'] != nil
            row['cod_cli'] =  row['cod_cli'].rjust(11, '0')  
           else
            row['cod_cli'] =  "000C_000001"
           end 
           
           row['processed'] = "0"
           
           
          a = Customer.find_by(account: row['cod_cli'].rjust(11, '0')   )
          
          if a == nil
            
          else
          puts "codigo cliente: "
          puts a.account
            
            if a.tipo == 3
                row['tipo'] = "2"
                row['fpago'] = "1"
                puts a.name 
            end 
          end 
          
             Sellvale.create! row.to_hash 
         end 
        #  Sellvale.where(cod_prod:"03").update_all(cod_prod:"05")
        #  Sellvale.where(cod_prod:"04").update_all(cod_prod:"03")
        #  Sellvale.where(cod_prod:"06").update_all(cod_prod:"04")
        #  Sellvale.where(cod_prod:"07").update_all(cod_prod:"05")
         
         
    end     
        
def self.import2(file2)
        TmpFactura.delete_all 
        
       CSV.foreach(file2.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
           
           
           row['numero'] =  row['numero'].rjust(6, '0')  
           valor = 0
           
          a = Customer.find_by(account: row['mcliente'].rjust(8, '0')   )
          
          if a == nil
              a=Customer.new
              a.company_id= 1
              a.name = "Cliente Puntos "
              a.ruc = row['mcliente']
              a.account = row['mcliente']
              a.saldo = row['puntos']     
              a.tipo = '3'
              a.save  
     
          else
             valor  = a.saldo + row['puntos'].to_i
             a.saldo = valor 
             a.save  
          end 
          
          b = Sellvale.find_by(serie: row['serie'] ,numero: row['numero']     )
          if b != nil 
            b.mpuntos = row['mcliente'] 
            b.puntos = row['puntos'].to_i  
            b.save 
          end 
             
         end 
    end     

    
  def get_customer_name(codigo) 
      
      a=Customer.find_by(account: codigo)
      
      if a
          
          return a.name 
      else 
          return "Codigo no existe"
          
      end 
      
  end       
  
  
    
  def get_descuento(codigo,producto) 
      
      b= 0
      a=Customer.find_by(account: codigo)
       
            if   producto =='01'
                return  a.d01 
            elsif   producto =='02'
                return  a.d02 
            elsif  producto =='03'
                return  a.d03
            elsif producto =='04'
                return  a.d04
            elsif producto =='05'
                return  a.d05
            elsif  producto =='08'
                return  a.d06
            else 
                return b 
            end 
      end       
    
  def get_product_name(codigo) 
      
      a=Product.find_by(code: codigo)
      
      if a
          
          return a.name 
      else 
          return "Nombre no existe..."
          
      end 
      
  end       
  
  def get_vale_facturado
      puts self.id
      ret = "Por facturar"
      
      facturas  = FacturaDetail.find_by_sql(["Select facturas.*
      from facturas 
      INNER JOIN factura_details  
      ON  facturas.id = factura_details.factura_id 
      where factura_details.sellvale_id = ?",self.id])
      
      if facturas  == nil
        return ret     
      else 
        for detalle in facturas
              ret =  detalle.code
              
        end  
        return ret
      end 


  end 
  
  
  
  def get_vale_facturado_fecha
      
      a = FacturaDetail.find_by(sellvale_id: self.id)
      if a 
         begin 
        b = Factura.find(a.factura_id)
        if b 
            return b.fecha  
        else
            return ""
        end 
        rescue 
        
    end 
      else
          return ""
      end

  end 
  
  def get_tarjeta_name(codigo) 
      
      a= Tarjetum.find(codigo)
      
      if a
          
          return a.nombre
      else 
          return "Tarjeta no existe"
          
      end 
      
  end       
 
def get_cliente(cliente)
     a= Customer.find_by(account: cliente)
     
    if a
         return a.name
    else
        return "Cliente no existe"
    end 
 end 
 
 def get_nombre_empleado(id)
     a= Employee.find_by(cod_emp: id)
     
    if a
         return a.full_name
    else
        return "Empleado no existe"
    end 
 end 
 
 def get_code_empleado(id)
     a= Employee.find_by(cod_emp: id)
     
    if a
         return a.id
    else
        return 0
    end 
 end 
 
 

def self.search(search_serie, search_numero) 
  # Title is for the above case, the OP incorrectly had 'name'
  #where("numero  iLIKE ? or cod_cli iLIKE ? or odometro ilike ? ", "%#{search}%","%#{search}%","%#{search}%")
  
  return scoped unless search_serie.present? || search_numero.present?
  where(['serie iLIKE ? AND numero iLIKE ?', "%#{search_serie}%", "%#{search_numero}%"])
  
end

   
def get_product2(id)        
    
    a = Product.find_by(code: id)
    return a.full_name
    
    
end 

  def  get_ventas_forma_pago_grifero_turno(fecha,grifero,turno,fpago) 

            ret = 0
             facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and cod_emp = ? and turno=?  and cod_tar= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",grifero,turno,fpago]).sum(:importe)
             
             if facturas
                 
                ret += facturas.importe.to_f    
            end 
        
            return ret
         
        end
        
        
        def  get_ventas_tirada_grifero_turno(fecha,grifero,turno ) 
        
             facturas = Tirad.where(["fecha >= ? and fecha <= ?  and employee_id = ? and turno = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",grifero,turno ])
             return facturas 
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
        
        def self.to_csv
            attributes = %w{id td fecha turno cod_emp caja serie numero cod_cli ruc placa odometro cod_prod cantidad precio importe igv fpago implista cod_tar km chofer tk_devol cod_sucu isla dni_cli tipo }

            CSV.generate(headers: true) do |csv|
            csv << attributes

                    all.each do |sellvale|
                    csv << attributes.map{ |attr| sellvale.send(attr) }
                end
            end
        end
        
         
   def get_empleado_nombre(id) 
      a= Employee.find(id)
      
      if a
          return a.full_name
      else
         return "Codigo No registrado "
      end 
     
   end  

        

end
