class Product < ActiveRecord::Base
  self.per_page = 20
  

  
  validates_presence_of :name, :company_id,:products_category_id,:price ,:punto,:code1,:code2  
  validates_numericality_of  :tax1, :tax2, :tax3
  validates_uniqueness_of :code

  belongs_to :company
  belongs_to :supplier
  belongs_to :products_category
  belongs_to :stock 
  belongs_to :product  

  has_many :movement_details
  has_many :items
  has_many :kits_products
  has_many :restocks
  has_many :invoice_products
  has_many :purchase_details
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :models
  has_many :marcas
  has_many :inventario_detalles
  has_many :output_details 
  has_many :ventaisla_details
  
  
  before_destroy :ensure_not_referenced_by_any_line_item


  
 TABLE_HEADERS = ["ITEM",
                  "CODIGO",
                  "DESCRIP  ",
                  "UNIDAD",
                  "UBICACION"]
                     

 def self.to_csv
    attributes = %w{id code code1 code2 name price }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

def self.matches(field_name, param)
    where("upper(#{field_name}) like ?", "%#{param}%")
end

def self.import(file)
  
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
            
          #Product.create! row.to_hash 
          
          row['cod_prod'] =  row['cod_prod'].rjust(13, '0')  
          
          a = Product.find_by(code: row['cod_prod'] )
          
            
            if  a == nil 
              
                a = Product.new(:name =>  row['nom_prod'], :company_id=>1,:products_category_id =>  row['category'], :price => row['precio'],:punto => 0 ,:tax1=> 0.00, :tax2 => 0.00, :tax3 => 0.00,:code => row['cod_prod'].rjust(13, '0') )
                a.save      
                
           else 
            
              puts  row['cod_prod'] 
              puts  row['category'] 
              puts  row['nom_prod'] 
              puts  a.id 
              
              a.update_attributes(products_category_id:  row['category'] ,name: row['nom_prod'] )
              
            
            end 
            
          
          end
  end 

  def add_category(category_txt)
    if(self.category != nil)
      # Add category
      category = ProductsCategory.where(company_id: self.company.id, category:  category_txt)
      
      if(not category)
        category = ProductsCategory.new(company_id: self.company.id, category: category_txt)
        category.save
      end
    end
  end
  
  def tax()
    total = 0
    
    if(self.tax1 and self.tax1 > 0)
      total += self.price * (self.tax1 / 100)
    end
    
    if(self.tax2 and self.tax2 > 0)
      total += self.price * (self.tax2 / 100)
    end
    
    if(self.tax3 and self.tax3 > 0)
      total += self.price * (self.tax3 / 100)
    end
    
    return total
  end
  
  def total()
    total = self.price
    
    if(self.tax1 and self.tax1 > 0)
      total += self.price * (self.tax1 / 100)
    end
    
    if(self.tax2 and self.tax2 > 0)
      total += self.price * (self.tax2 / 100)
    end
    
    if(self.tax3 and self.tax3 > 0)
      total += self.price * (self.tax3 / 100)
    end
    
    return total
  end
  
  def profit()
    return self.price - self.cost
  end
  
  def full_name()
    if(self.code and self.code != "")
      name = self.code + ": " + self.name
    else
      name = self.name
    end
    
    return name

  end

def get_ventaisla_detail_qty(fecha1,fecha2,producto)

    facturas = Ventaisla.where(["fecha >= ? and fecha<= ?  ", 
       "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
    ret = 0
    
      for factura in facturas      
                
          @detail = VentaislaDetail.where(ventaisla_id:factura.id, product_id: producto)

          for d in @detail 
             ret  += d.quantity * -1 
            
          end 

      end

      return ret
 end 
 
def get_ventaisla_detail_importe(fecha1,fecha2,producto)

    facturas = Ventaisla.where(["fecha >= ? and fecha <= ?  ", 
       "#{fecha1} 00:00:00","#{fecha2} 23:59:59" ])
    ret = 0
    
      for factura in facturas      
                
          @detail = VentaislaDetail.where(ventaisla_id:factura.id, product_id: producto)

          for d in @detail 
             ret  += d.quantity * d.price * -1 
            
          end 

      end

      return ret
 end 


 

private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
  if line_items.empty?
  return true
  else
  errors.add(:base, 'Line Items present')
  return false
  end
  end

end
