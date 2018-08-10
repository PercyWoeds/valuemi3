class Sellvale < ActiveRecord::Base
 
 validates_presence_of :fecha,:turno,:td,:caja,:serie,:numero,:cod_cli,:placa,:cod_prod,:placa,:cod_prod,:cantidad,:precio,:tipo,:td ,:fpago  
 validates_uniqueness_of :numero, scope: :serie
 
 belongs_to :factura_detail
    
def self.import(file)
        TmpFactura.delete_all 
        
       CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
           
           
           row['cod_prod'] =  row['cod_prod'].rjust(2, '0')  
           
           if row['cod_cli'] != nil
            row['cod_cli'] =  row['cod_cli'].rjust(11, '0')  
           else
            row['cod_cli'] =  "C_000001"
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
    
  def get_product_name(codigo) 
      
      a=Product.find_by(code: codigo)
      
      if a
          
          return a.name 
      else 
          return "Nombre no existe..."
          
      end 
      
  end       
  
  def get_vale_facturado
      
      a = FacturaDetail.find_by(sellvale_id: self.id)
      if a 
         begin 
        b = Factura.find(a.factura_id)
        if b 
            return b.code  
        else
            return ""
        end 
        rescue 
        
    end 
      else
          return ""
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

def self.search(search)
  # Title is for the above case, the OP incorrectly had 'name'
  where("numero  iLIKE ? or cod_cli iLIKE ? ", "%#{search}%","%#{search}%")
end
 

end
