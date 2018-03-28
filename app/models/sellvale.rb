class Sellvale < ActiveRecord::Base
    
    
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
          
          
        end
    end     



end
