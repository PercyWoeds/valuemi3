class Viatico < ActiveRecord::Base
    
    
self.per_page = 20


  validates_presence_of :company_id,  :code, :user_id,:inicial,:fecha1
  validates_uniqueness_of :code, scope: :caja_id
  
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier
  belongs_to :document 
  
  belongs_to :user
  belongs_to :caja
  belongs_to :employee 

  has_many   :viatico_details , :dependent => :destroy
  
  
   TABLE_HEADERS = ["ITEM",
                      "FECHA ",
                      "TD",
                      "DOCUMENTO",
                      "PROVEEDOR"
                      "DESCRIP",
                      "INGRESO ",
                      "EGRESO  "
                                           ]

  TABLE_HEADERS2 = ["TD",
                      "Documento",
                     "Fecha",
                     "Cliente",
                     "Moneda",
                     "SUBTOTAL",
                     "IGV.",
                     "TOTAL",
                     "ESTADO"]
                     
  TABLE_HEADERS3 = ["TD",
                      "Documento",
                     "Fecha",
                     "Fec.Vmto",
                     "Cliente",
                     "Moneda",                                         
                     "SOLES",
                     "DOLARES ",
                     "DETRACCION",
                     "OBSERV"]
  
 TABLE_HEADERS4  = ["ITEM",
                      "FECHA",
                     "PROVEEDOR/EMPLEADO",
                     "COMPROBANTE",
                     "INGRESO",                                         
                     "EGRESO",
                     "OST ",
                     "DETALLE",
                     "DESTINO"]
  

  def self.search(search)
      where("code LIKE ?", "%#{search}%") 
        
  end



  def self.to_csv(result)
    unless result.nil?
      CSV.generate do |csv|
        csv << result[0].attributes_names
        result.each do |row|
          csv << row.attributes.values
        end
      end
    end   
  end

  def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Factura.create! row.to_hash 
        end
  end      
  def get_moneda(id)
    a = Moneda.find(id)

    return a.description
  end
  def get_vencido

      if(self.fecha2 < Date.today)   

        return "** Vencido ** "
      else
        return ""
      end 

  end 

  def my_deliverys
        @deliveryships = Delivery.all 
        return @deliveryships
  end 

  def correlativo      
        numero = Voided.find(2).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'2').update_all(:numero =>lcnumero)        
  end

  def correlativo2(dato)
    ret = ""
     lcNumero = dato.to_i + 1
     ret = lcNumero.to_s.rjust(6, '0')   
     return ret 
  end 
   def get_total_inicial
  
    subtotal = self.inicial
    
    return subtotal 
    
  end
  
  def get_total_ing
    subtotal = 0
    
    @viatico_details = ViaticoDetail.where(viatico_id: self.id)
    
    for item in  @viatico_details 
    
        if item.tm == "6"
          total = item.importe
        else
          total = 0
        end
        
        begin
          subtotal += total
        rescue
        end
        
      end
  
    
    return subtotal
  end
  
  def get_total_sal
    subtotal = 0
      
    @viatico_details = ViaticoDetail.where(viatico_id: self.id)
    
  for item in  @viatico_details 
  
    
         
        if item.tm == "6"
            total = 0
          else
            total = item.importe
          end 
        
        begin
          subtotal += total
        rescue
        end
        
      end
  
    return subtotal
  end
  
  
  def get_total_ingreso
    subtotal = 0
    
    @viatico_details = ViaticoDetail.where(viatico_id: self.id)
    
    for item in  @viatico_details 
    
        if item.tipomov_id == 1 and item.tm != "5"
          total = item.importe
        else
          total = 0
        end
        
        begin
          subtotal += total
        rescue
        end
        
      end
  
    
    return subtotal
  end
  
  def get_total_egreso
    subtotal = 0
    
    @viatico_details = ViaticoDetail.where(viatico_id: self.id)
    
    for item in  @viatico_details 
    
        if item.tipomov_id == 2 and item.tm != "5"
          total = item.importe
        else
          total = 0
        end
        
        begin
          subtotal += total
        rescue
        end
        
      end
  
    
    return subtotal
  end
  
  
  def delete_products()
    invoice_services = ViaticoDetail.where(viatico_id: self.id)
    
    for ip in invoice_services
      ip.destroy
    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id       = parts[0]
        quantity = parts[1]
        detalle1 = parts[2]
        tm1      = parts[3]
        detalle2 = parts[5]
        fecha    = parts[6]
        ac_supplier = parts[7]
        gasto      = parts[8]
        empleado   = parts[9]
        
        total    =  quantity.to_f
        
          product = Tranportorder.find(id.to_i)
          
          new_invoice_product = ViaticoDetail.new(:viatico_id => self.id,:descrip=> detalle2,:importe=> total ,:detalle=> detalle1,:tm=>tm1,:tranportorder_id=> product.id,:fecha=>fecha,:supplier_id =>ac_supplier.to_i ,:gasto_id=> gasto.to_i,:employee_id=> empleado )

          new_invoice_product.save
          if tm1.to_i != 6
            new_compro = Compro.new(:ost_id=> self.id ,:importe=> total,:detalle=>detalle1,:company_id=>1,:location_id=>1,:division_id=>1,:tranportorder_id=>product.id,:code=>detalle2,:fecha=>fecha)
            new_compro.save 
          end
          
    
      end
    end
  end

  
  def add_guias(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        
        begin
          @guia = Delivery.find(id.to_i)

          @guia.processed='4'
          @guia.facturar 
          
          new_invoice_guia = Deliveryship.new(:factura_id => self.id, :delivery_id => @guia.id)          
          new_invoice_guia.save
           
        rescue
          
        end
      end
    end
  end
  

 def delete_guias()
    invoice_guias = Deliveryship.where(factura_id: self.id)
    
    for ip in invoice_guias
      ip.destroy
    end
  end

  def identifier
    return "#{self.code} "
  end
  def get_viaticos
      @viaticos = ViaticoDetail.where("viatico_id = ? ",self.id)
  end

  def get_viaticos_cheque
      lcCheque = 6
      @viaticos = ViaticoDetail.where("viatico_id = ? and document_id = ?",self.id, lcCheque).order(:tipomov_id,:gasto_id,:id,:document_id)
  end

  def get_viaticos_lima
      lcCheque = 6
      @viaticos = ViaticoDetail.where("viatico_id = ? and document_id <> ? and destino_id = ? ",self.id, lcCheque,1).order(:tipomov_id,:gasto_id,:id,:document_id)
  end
  
  def get_viaticos_provincia
      lcCheque = 6
      @viaticos = ViaticoDetail.where("viatico_id = ? and document_id <> ? and destino_id = ?",self.id, lcCheque,2).order(:tipomov_id,:gasto_id,:id,:document_id)
  end
  

  def get_invoices
    @facturas= Factura.find_by_sql(['Select facturas.*,customers.ruc,payments.descrip from facturas 
      LEFT JOIN customers on facturas.customer_id = customers.id 
      LEFT JOIN payments  on facturas.payment_id = payments.id'])
      return @facturas
  end 

  def get_facturas(id)
  
    @facturas= Factura.where(["balance > 0  and customer_id = ?",  id ])

    return @facturas
  end 


  
  def get_invoices_details

  
    
  end 

  def get_products2(id)    
    @itemproducts = InvoiceService.find_by_sql(['Select invoice_services.price,
      invoice_services.quantity,invoice_services.discount,invoice_services.total,services.name 
     from invoice_services INNER JOIN services ON invoice_services.service_id = services.id where invoice_services.factura_id = ?', id ])
    
    return @itemproducts
  end

  def get_products    
    @itemproducts = InvoiceService.find_by_sql(['Select invoice_services.price,
    	invoice_services.quantity,invoice_services.discount,invoice_services.total,services.name 
  	 from invoice_services INNER JOIN services ON invoice_services.service_id = services.id where invoice_services.factura_id = ?', self.id ])
    
    return @itemproducts
  end
  
  def get_guias    
    @itemguias = Deliveryship.find_by_sql(['Select deliveries.id,deliveries.code,deliveries.description 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=2 and  deliveryships.factura_id = ?', self.id ])
    return @itemguias
  end

  def get_guiasremision 
    @itemguias1 = Deliveryship.find_by_sql(['Select deliveries.code 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=1 and  deliveryships.factura_id = ?', self.id ])
    return @itemguias1
  end
  def get_guias2(id)    
    @itemguias = Deliveryship.find_by_sql(['Select deliveries.id,deliveries.code,deliveries.description,deliveries.processed
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=2 and  deliveryships.factura_id = ?', id ])
    return @itemguias
  end

  def get_guiasremision2(id)
    @itemguias1 = Deliveryship.find_by_sql(['Select deliveries.code 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=1 and  deliveryships.factura_id = ?', id ])
    return @itemguias1
  end

  def get_guias_remision(id)    
        
    guias = []
    invoice_guias = Deliverymine.where(:mine_id => id)
    return invoice_guias
        
  end
  

  def get_invoice_products
    invoice_products = InvoiceService.where(factura_id:  self.id)    
    return invoice_products
  end
  
  def viaticos_lines
    services = []
    
    viatico_header = Viatico.where(id: self.id)
    
    invoice_products = ViaticoDetail.where(viatico_id:  self.id)
    
    
    viatico_header.each do  | ip |
      
      inicial = ip.inicial 
      
    end 
    
    
    
    
    ruc = ""
    gasto = 0
    i= 0  
    
      invoice_products.each do | ip |
      i +=1
      ip.tranportorder[:CurrTotal] = ip.importe
      ip.tranportorder[:detalle] = ip.detalle
      ip.tranportorder[:tm]      = ip.tm
      ip.tranportorder[:comprobante]  = ip.descrip
      ip.tranportorder[:fecha]  = ip.fecha 
      ip[:supplier_id] = ip.supplier_id
      ip[:gasto_id]    = ip.gasto_id
      
      services.push("#{ip.tranportorder.id}|BRK|#{ip.tranportorder.CurrTotal}|BRK|#{ip.tranportorder.detalle}|BRK|#{ip.tranportorder.tm}|BRK|#{inicial}|BRK|#{ip.tranportorder.comprobante}|BRK|#{ip.tranportorder.fecha}|BRK|#{ip.supplier_id}|BRK|#{ip.gasto_id} ")
    end
    
    return services.join(",")
  end
  
  def guias_lines
    guias = []
    invoice_guias = DeliveryShip.where(factura_id:  self.id)
    
    invoice_guias.each do | ip |
      guias.push("#{ip.delivery.id}|BRK|")
    end    

    return guias.join(",")
  end
  
    def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cerrado --"  

    elsif (self.processed == "4")

      return "-Facturado --"  

    else   
      return "No Aprobado"
        
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
      return "Yes"
    elsif (self.processed == "3")
       return "Yes"
    else
      return "No"
    end
  end
  
  def get_return
    if(self.return == "1")
      return "Yes"
    else
      return "No"
    end
  end
  # Process the invoice
  def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.zone.now
      self.save
    end
  end
  def cerrar
    if(self.processed == "3" )         
      
      self.processed="3"
      self.date_processed = Time.now
      self.save
    end
  end
  
  # Process the invoice
  def anular
    if(self.processed == "2" )          
      self.processed="2"
      self.subtotal =0
      self.tax = 0
      self.total = 0
      self.balance = 0
      
      self.date_processed = Time.now
      self.save
    end
  end

  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end
 
  def correlativo      
        numero = Voided.find(13).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'13').update_all(:numero =>lcnumero)        
  end

def  get_ventas_fecha_turno(fecha,fpago,turno ) 

            ret = 0
             facturas = Sellvale.where(["fecha >= ? and fecha <= ?   and cod_tar= ? and turno = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",fpago,"#{turno}"])
             
             if facturas
                 
               for factura in facturas      
                ret += factura.importe.to_f 
                end
             end 
        
            return ret
         
  end
     def  get_ventas_tirada_turno(fecha,turno ) 
              ret  = 0
             facturas = Tirad.where(["fecha >= ? and fecha <= ?   and turno = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",turno ])
             if facturas
                for factura in facturas      
                ret += factura.importe 
                end

             end  
             return ret

         end 



        def  get_ventas_combustibles_fecha_grifero0(fecha1,turno) 

            @forma_pago='98'
            @turno = turno.to_s 
            facturas = Sellvale.find_by_sql(['Select sellvales.cod_emp,sellvales.turno, 
                    SUM(sellvales.cantidad) AS quantity,
                    SUM(CAST(importe AS numeric)) AS total 
                      from sellvales 
                      INNER JOIN employees ON sellvales.cod_emp = employees.cod_emp
                      INNER JOIN products ON  sellvales.cod_prod = products.code 
                      WHERE sellvales.fecha >= ? and sellvales.fecha <= ? and sellvales.cod_tar = ? and sellvales.turno = ?
                      GROUP BY sellvales.fecha, sellvales.turno,sellvales.cod_emp
                      ORDER BY sellvales.fecha, sellvales.turno,sellvales.cod_emp
                      ', "#{fecha1} 00:00:00","#{fecha1} 23:59:59",@forma_pago, @turno  ])  
            
            return facturas 
            
        end 

def  get_ventas_tirada_emp_turno(fecha,cod_emp, turno ) 
          ret  = 0
         facturas = Tirad.where(["fecha >= ? and fecha <= ?  and cod_emp = ?   and turno = ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",cod_emp,turno ])
         if facturas
            for factura in facturas      
            ret += factura.importe 
            end

         end  
         return ret

 end 


 
  def  get_ventas_forma_pago(fecha,fpago) 

            facturas  = 0

             facturas = Sellvale.find_by_sql(['Select SUM(CAST(importe AS numeric)) AS total 
                         from sellvales where fecha >= ? and fecha <= ?   
                         and cod_tar= ?' , "#{fecha} 00:00:00","#{fecha} 23:59:59",
                         fpago  ])

            if facturas.first.total != nil  
                puts "aaaaa"
                puts facturas.first.total  
              return facturas.first.total  
            else 
               return 0
            end                
            
        
         
  end
  
 def  get_ventas_forma_pago_grifero_turno_detalle(fecha,grifero,turno,fpago) 

            ret = 0
             facturas = Sellvale.where(["fecha >= ? and fecha <= ?  and cod_emp = ? and turno=?  and cod_tar= ?  " , "#{fecha} 00:00:00","#{fecha} 23:59:59",grifero,turno,fpago])
             
            
        
            return facturas 
         
  end
  


  def  get_ventas_forma_pago_grifero_turno_total(fecha,grifero,turno,fpago) 

            facturas  = 0

             facturas = Sellvale.find_by_sql(['Select SUM(CAST(importe AS numeric)) AS total 
                         from sellvales where fecha >= ? and fecha <= ?   
                         and cod_emp = ?  and turno = ? and  cod_tar= ?' , "#{fecha} 00:00:00","#{fecha} 23:59:59",
                         cod_emp,turno, fpago  ])

            if facturas.first.total != nil  
                puts "aaaaa"
                puts facturas.first.total  
              return facturas.first.total  
            else 
               return 0
            end                
            
        
         
  end
      
end



