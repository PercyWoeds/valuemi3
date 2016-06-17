class ProductsCategory < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :category
  
  belongs_to :company

   def self.import(file)
          CSV.foreach(file.path, headers: true) do |row|
          ProductsCategory.create! row.to_hash 
     end
  end 

end
