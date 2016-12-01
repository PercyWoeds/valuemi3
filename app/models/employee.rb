class Employee < ActiveRecord::Base

	before_save :set_full_name

	private 

	def set_full_name
		self.full_name ="#{self.firstname} #{self.lastname}".strip		

	end 
	
	def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          Employee.create! row.to_hash 
        end
    end       
    

end
