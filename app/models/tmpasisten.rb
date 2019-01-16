class Tmpasisten < ActiveRecord::Base
    
    
      def get_empleado_nombre(codigo) 
      
      a= Employee.find_by(cod_emp: codigo)
      
      if a
          
          return a.full_name
      else 
          return "Empleado no existe"
          
      end 
      
  end       
  
end
