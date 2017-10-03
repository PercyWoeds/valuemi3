class Loan < ActiveRecord::Base
    
    validates_presence_of :payroll_id, :descrip
    
    
    has_many :loan_details, :dependent => :destroy
    
end
