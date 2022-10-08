class Tipocambio < ActiveRecord::Base


     def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Tipocambio.create! row.to_hash 
        end
    end     
    
    def start_time
        self.dia ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
    end

    
end
