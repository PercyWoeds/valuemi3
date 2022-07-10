class Tirad < ActiveRecord::Base
    
    belongs_to :employee
    
    
    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
              
          a = Employee.find_by(cod_emp: row['cod_emp'].rjust(4, '0')   )
          
          if a == nil
                row['employee_id'] = 10
          else
                row['employee_id'] = a.id
                
          end 
              
          
          Tirad.create! row.to_hash 
          
        end
    end     



   def self.to_csv(options = {})
      CSV.generate(options) do |csv|
      csv << column_names
      all.each do |tirad|
        csv << tirad.attributes.values_at(*column_names)
      end
    end   
    end 
  

end
