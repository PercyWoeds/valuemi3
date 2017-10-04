class LoanDetail < ActiveRecord::Base
    
     belongs_to :loan 
     belongs_to :employee
     belongs_to :valor
     
end
