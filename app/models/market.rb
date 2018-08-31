class Market < ActiveRecord::Base
    
 validates_presence_of :fecha, :turno,:td,:caja,:serie,:numero,:cod_cli,:cantidad,:precio,:td,:fpago,:cod_prod 
 

    
    def self.import(file)
        
        
       CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
           
           
           row['cod_prod'] =  row['cod_prod'].rjust(13, '0')  
           
           if row['cod_cli'] != nil
            row['cod_cli'] =  row['cod_cli'].rjust(11, '0')  
           else
            row['cod_cli'] =  "C_000001"
           end 
           
           row['processed'] = "0"
           
           Market.create! row.to_hash 
           
         end 
         
         
    end     


def self.search(search)
  # Title is for the above case, the OP incorrectly had 'name'
  where("numero  iLIKE ? or cod_cli iLIKE ? ", "%#{search}%","%#{search}%")
end    
    
end
