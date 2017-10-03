class Payroll < ActiveRecord::Base
    
    validates_presence_of :type_payroll_id, :parameter_id,:fecha,:fecha_inicial,:company_id,:user_id
    
    has_many :type_payrolls
    has_many :payroll_details, :dependent => :destroy
    
    
     TABLE_HEADERS = ["ITEM",
                     "CANTIDAD",
                     "CODIGO",
                     "DESCRIPCION",
                     "PRECIO UNITARIO",
                     "DSCTO",
                     "VALOR TOTAL"]

   
   def process

      planilla  =Employee.where(active: "1")
      
      PayrollDetail.where(payroll_id: self.id).delete_all
      
      #Selecciona datos para calcular onp essalud
      
      lcOnp= 0
      lcSctr1 = 0
      lcSctr2 = 0
      lcEssalud = 0
      
      @detalle = Parameter.find(self.parameter_id)
      
      lcOnp = @detalle.onp
      lcSctr1 = @detalle.sctr_1
      lcSctr2 = @detalle.sctr_2
      lcEssalud = @detalle.essalud 
     
      for ip in planilla
                
        #actualiza stock
        lccalc1= 0
        lccalc2= 0
        lccalc3= 0
        
        
      #Selecciona datos para calcular afp  
        lcafp=0
        lccalc4=0
        lccalc5=0
        lccalc6=0
        lccalc7=0
        
        lccalc8=0
        lccalc9=0
        lccalc10=0
        
        lctotal2=0
        lctotal3=0
        
        totalremu = ip.sueldo+lccalc1+lccalc2+lccalc3
        
        lcafp = ip.get_afp(@detalle.id)            
        
        
        if ip.onp == "1"
            lccalc5 = lcOnp/100 * totalremu
        else
            lccalc5 = 0
            lccalc6 = lcafp/100 * totalremu        
        end 
        
        
        lccalc8  = lcEssalud/100 * totalremu
        lccalc9  = lcSctr1/100 * totalremu
        lccalc10 = lcSctr2/100 * totalremu    
        lctotal3 = lccalc8+lccalc9+lccalc10
        
        lctotal2 = lccalc4 + lccalc5 + lccalc6 + lccalc7
        lcneto = totalremu -lctotal2
        
        a=  PayrollDetail.new(employee_id: ip.id, remuneracion: ip.sueldo, calc1: 0, calc2: 0, calc3: 0, total1: totalremu,
        calc4: 0, calc5: lccalc5.round(2), calc6: lccalc6.round(2), calc7: 0, total2: lctotal2, remneta: lcneto, calc8: lccalc8, calc9: lccalc9, calc10: lccalc10,
        total3: lctotal3, payroll_id: self.id)
        
        a.save

        self.date_processed = Time.now
        self.save
      

      end
    end   

   
    
end
