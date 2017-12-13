class Bankdetail < ActiveRecord::Base
    
    validates_presence_of  :company_id,:fecha
    validates_numericality_of  :saldo_inicial,:saldo_final,:total_abono,:total_cargo
    
    belongs_to :bank_acount
    
    
end
