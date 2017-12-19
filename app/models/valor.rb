class Valor < ActiveRecord::Base
    
    
    has_many :payroll_details 
    has_many :payrollbonis
    
end
