class Payrollboni < ActiveRecord::Base
   
   validates_presence_of :employee_id,:tm_id,:valor_id ,:payroll_id 
   
    belongs_to :payroll 
    belongs_to :employee
    belongs_to :tm 
    belongs_to :valor 
    
end
