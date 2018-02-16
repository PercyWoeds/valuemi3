class Gasto < ActiveRecord::Base
     validates_presence_of :descrip 
    before_save :set_fullcuenta
    before_update :set_fullcuenta
  
    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Gasto.create! row.to_hash 
        end
    end     
    def set_fullcuenta
         self.fullcuenta ="#{self.codigo} #{self.descrip}".strip		

    end 
end
