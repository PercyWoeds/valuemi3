class Product < ActiveRecord::Base
  self.per_page = 20
  

  
  validates_presence_of :name, :company_id,:products_category_id,:price 
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
                  "UBICACION",
                     ]


def self.matches(field_name, param)
    where("upper(#{field_name}) like ?", "%#{param}%")
end

  def self.import(file)
          CSV.foreach(file.path, headers: true) do |row|
          Product.create! row.to_hash 
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
