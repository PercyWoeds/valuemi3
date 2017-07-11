class Gasto < ActiveRecord::Base
     validates_presence_of :descrip 
  
    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Gasto.create! row.to_hash 
        end
    end     
end
