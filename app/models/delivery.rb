class Delivery < ActiveRecord::Base

self.per_page = 20

  validates_uniqueness_of :code
  
  validates_presence_of :company_id, :customer_id, :code, :user_id,:fecha1,:fecha2
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :customer
  belongs_to :user
  belongs_to :truck 
  belongs_to :employee
  belongs_to :subcontrat
  belongs_to :address
  belongs_to :tranportorder
  
  has_many :delivery_services
  has_many :declarationdeliveries

  has_many :deliverymines
  has_many :mines, through: :deliverymines

  

  TABLE_HEADERS = ["ITEM",
                     "Fecha",
                     "FEC.ING.",
                     "Fec.Ope.",
                     "Fec.Cont.",
                     "TD",
                     "NUMERO",
                     "CLIENTE",
                     "DESTINO",
                     "DESCRIP",
                     "ORDEN",                     
                     "ORIGEN",                     
                     "DESTINO",                     
                     "ESTADO"]
  TABLE_HEADERS1 = ["ITEM",
                     "FECHA",
                     "FEC.ING.",
                     "TD",
                     "NUMERO",
                     "CLIENTE",
                     "DESTINO",
                     "ESTADO"]

  TABLE_HEADERS2 = ["ITEM",
                     "FECHA",
                     "FEC.ING.",
                     "TD",
                     "NUMERO",
                     "CLIENTE",
                     "DESTINO",
                     "ESTADO"]                     
  TABLE_HEADERS3 = ["ITEM",
                     "FECHA",
                     "FEC.ING.",
                     "Fec.Ope.",
                     "Fec.Cont.",                     
                     "TD",
                     "NUMERO",
                     "CLIENTE",
                     "DESTINO",
                     "ESTADO"]                     

def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Delivery.create! row.to_hash 
        end
    end      


def not_guias_with?(mine_id)
    Deliverymine.where(mine_id: mine_id).count < 1
end



def self.search(params)        
    customers = Factura.where("name  LIKE ?","%#{params[:search]}%") if params[:search].present?
    customers
end

def get_guiaremision
  @guiaremision= Delivery.where(:remite_id => self.customer_id, :remision=> "1")
  return @guiaremision
end 

def get_direccion(id)
  
  guiaorigen = Address.find(id)

  return guiaorigen.full_address

end 

def get_origen(id)
  guiaorigen = Customer.find(id)

  return guiaorigen.name 

end 

def not_delivery_with?(delivery_code)
    Delivery.where(code: delivery_code).count < 1
end


def self.search(param)
    return Delivery.none if param.blank?
    param.strip!
    param.downcase!
    (code_matches(param)).uniq
end

def self.code_matches(param)
    matches('code', param)
end

def self.matches(field_name, param)
    where("lower(#{field_name}) like ?", "%#{param}%")
end

  def correlativo
        
        numero = Voided.find(1).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'1').update_all(:numero =>lcnumero)        
  end

  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        unidad_id  = parts[2]
        peso = parts[3]
        price = parts[4]
        discount = parts[5]
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          product = Service.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  def get_tax(items, customer_id)
    tax = 0
    
    customer = Customer.find(customer_id)
    
    if(customer)
      if(customer.taxable == "1")
        for item in items
          if(item and item != "")
            parts = item.split("|BRK|")
        
            id = parts[0]
            quantity = parts[1]
            unidad_id  = parts[2]
            peso     = parts[3]
            price    = parts[4]
            discount = parts[5]
            
            total = price.to_f * quantity.to_i
            total -= total * (discount.to_f / 100)
        
            begin
              product = Service.find(id.to_i)
              
              if(product)
                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)
                end
                
              end
            rescue
            end
          end
        end
      end
    end
    
    return tax
  end
  
  def delete_services()
    delivery_services = DeliveryService.where(delivery_id: self.id)
    
    for ip in delivery_services
      ip.destroy
    end
  end
  
  def add_services(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        unidad_id  = parts[2]
        peso     = parts[3]
        price    = parts[4]
        discount = parts[5]
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          service = Service.find(id.to_i)
          new_delivery_service = DeliveryService.new(:delivery_id => self.id, :service_id => service.id, :price => price.to_f, :quantity => quantity.to_i,:unidad_id=> unidad_id.to_i,:peso=>peso.to_i, :discount => discount.to_f, :total => total.to_f)
          new_delivery_service.save

        rescue
          
        end
      end
    end
  end
  
  def identifier
    return "#{self.code} - #{self.customer.name}"
  end

  def get_ost(id) 
    @punto =Tranportorder.find(id)
    return @punto
  end 
  def get_punto(id) 
    @punto = Punto.find(id)
    return @punto.name 
  end

  

  

  def get_services   
    @itemservices = DeliveryService.find_by_sql(['Select delivery_services.price,delivery_services.quantity,delivery_services.discount,
delivery_services.total,delivery_services.unidad_id,delivery_services.peso,services.name  
from delivery_services INNER JOIN services ON delivery_services.service_id = services.id 
where delivery_services.delivery_id = ?', self.id ])


    return @itemservices

  end
  
  def get_delivery_services
   	delivery_services = DeliveryService.where(delivery_id:  self.id)    
    return delivery_services
  end

  
  def services_lines
    services = []
    delivery_services = DeliveryService.where(delivery_id:  self.id)
    
    delivery_services.each do | ip |

      ip.service[:price]    = ip.price
      ip.service[:quantity] = ip.quantity
      ip.service[:unidad_id] = ip.unidad_id 
      ip.service[:peso]     = ip.peso
      ip.service[:discount] = ip.discount
      ip.service[:total]    = ip.total
      #products.push("#{ip.product.id}|BRK|#{ip.product.curr_quantity}|BRK|#{ip.product.curr_price}|BRK|#{ip.product.curr_discount}")
        services.push("#{ip.service.id}|BRK|#{ip.service.quantity}|BRK|#{ip.service.unidad_id}|BRK|#{ip.service.peso}|BRK|#{ip.service.price}|BRK|#{ip.service.discount}")
    end


    return services.join(",")
  end
  
  def get_processed
    if(self.processed == "1")
      return "Aprobado "
    elsif (self.processed == "2")      
      return "**Anulado **"
    elsif (self.processed == "3")      
      return "* Cerrado **"
    elsif (self.processed == "4")        
      return "* Facturado **"
    else 
      return "No Aprobado"
        
    end
  end
  
  def get_remision
    if(self.remision == 1)
      return "GR"    
    else 
      return "GT"
        
    end
  end
  def get_processed_short
    if(self.processed == "1")
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
  def get_truck2(truck2_id)

    @truck2= Truck.find(truck2_id).placa
    return  @truck2
    
  end
  
  
  
  def process

    if(self.processed == "1" or self.processed == true)            
      self.date_processed = Time.now
      self.save
    end
  end


  def anular

    if(self.processed == "2")            
      self.date_processed = Time.now
      self.save
    end
  end
  
  def facturar

    if(self.processed == "4")            
      self.processed = "4"
      self.date_processed = Time.now
      self.save
    end
  end
  

  
  # Color for processed or not
  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end
end

