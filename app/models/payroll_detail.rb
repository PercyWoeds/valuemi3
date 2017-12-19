class PayrollDetail < ActiveRecord::Base
    before_save :set_dias_trab
    before_update :set_dias_trab
    
    belongs_to :payroll 
    belongs_to :employee
    
    private
    def set_dias_trab
       
       if self.totaldia == nil 
           self.totaldia = 0
       end
       if self.falta == nil 
           self.falta = 0
       end
       if self.vaca == nil 
           self.vaca = 0
       end
       
       
       self.dias = self.totaldia + self.falta + self.vaca 
    end
    
end
