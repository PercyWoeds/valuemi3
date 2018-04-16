class Sellvale < ActiveRecord::Base
 validates_uniqueness_of :numero
 validates_presence_of :fecha,:turno,:td,:caja,:serie,:numero,:cod_cli,:placa,:cod_prod,:placa,:cod_prod,:cantidad,:precio,:tipo 
 validates_uniqueness_of :numero, scope: :serie
    
    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
           
           
           row['cod_prod'] =  row['cod_prod'].rjust(2, '0')  
           
           if row['cod_cli'] != nil
            row['cod_cli'] =  row['cod_cli'].rjust(11, '0')  
           else
            row['cod_cli'] =  ""
           end 
           
           row['processed'] = "0"
           
           
           
           
          Sellvale.create! row.to_hash 
          
          
          a = Customer.find_by(account: row['cod_cli'] )
          if a == nil
            lcCustomerId = 7      
          else
            lcCustomerId = a.id
          end 
          a = Product.find_by(code: row['code'] )
          if a != nil
            lcCustomerId = a.id
          end 
          
          
          lcCode = row['serie'] << "-" << row['numero']
          
          if row['td']!="N"
                  lcVventa0 = row['importe'].to_f / 1.18
                  lcVventa =lcVventa0.round(2)
                  lcTax0   =  row['importe'].to_f  - lcVventa
                  lcTax    = lcTax0
                  lcTotal0 = row['importe'].to_f 
                  lcTotal  = lcTotal0.round(2)  
                  lcDocumentId =3
            else
                  lcDocumentId = 3
                  lcVventa= 0
                  lcTax = 0
                  lcTotal = 0
            end 
          lcFecha = row['fecha']
          lcTipoVale ='1'
          lcRucCliente =row['ruc']
          
        #  a= Factura.new(company_id:1,location_id:1, division_id: 1, customer_id: lcCustomerId , description: "", comments:"", code: lcCode ,
        #  subtotal: lcVventa , tax: lcTax , total: lcTotal, processed: "0", date_processed: Date.today, user_id: 1, fecha: lcFecha, 
        #  serie: row['serie'], numero:  row['numero'], payment_id: 8,  charge: 0, balance: lcTotal, moneda_id: 2, 
        #  observ: "VENTA PLAYA", fecha2: lcFecha, detraccion: 0, numero2: "", document_id: 3, descuento: 0,tipo: lcTipoVale,ruc:lcRucCliente )
        #  a.save
         
         
          
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


end
