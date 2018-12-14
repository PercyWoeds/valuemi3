class Tirad < ActiveRecord::Base
    
    belongs_to :employee
    
    
    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Tirad.create! row.to_hash 
        end
    end     


  

end
