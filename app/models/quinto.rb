class Quinto < ActiveRecord::Base
    before_save :calcular
    before_update :calcular
    
    belongs_to :employee
    
    def calcular
        
        @fives = Fiveparameter.find_by(anio: self.anio)
        
        mes =self.mes 
        lcMes_proyectado = 12 - mes 
        
        self.mes_proy = lcMes_proyectado
        self.rem_proyectada = self.mes_proy * self.rem_actual
        self.renta_bruta = self.ene1 + self.feb1 + self.mar1 + self.abr1 + self.may1 + self.jun1 + self.jul1 + self.ago1 + self.set1 + self.oct1 + self.nov1 + self.gratijulio1  + self.rem_mes + self.asignacion + self.hextras + self.otros1 + self.rem_proyectada + self.gratijulio + self.gratidic + self.bonextra + self.otros2
        puts "renta bruta"
        puts renta_bruta

        
        if ((@fives.valor_uit * 7) > self.renta_bruta)
            self.deduccion7 = self.renta_bruta
        else
            self.deduccion7 = @fives.valor_uit * 7 
        end 
        
        self.total_renta =  self.renta_bruta - self.deduccion7
        
        #Hasta 5 UIT
        impo1_hasta_5 = @fives.hasta_5
        impo1_tasa    = @fives.tasa1
        
        impo2_exceso_5 = @fives.exceso_5
        impo2_y_hasta_20 = @fives.y_hasta_20
        impo3_exceso_20 =@fives.exceso_20
        impo3_y_hasta_35 =@fives.y_hasta_35
        impo4_exceso_35 = @fives.exceso_35
        impo4_y_hasta_45 = @fives.y_hasta_45
        impo5_exceso_45 = @fives.exceso_45
        
        tramo1 = 0
        if self.total_renta > impo1_hasta_5 
            self.renta_impo1 = impo1_hasta_5
            self.renta_anual_1 = impo1_hasta_5 * (impo1_tasa / 100)
            
        else
            self.renta_impo1 = self.total_renta
            self.renta_anual_1 = self.total_renta * (impo1_tasa / 100)
        end 
        
        if (self.total_renta > impo2_exceso_5 and self.total_renta <= impo2_y_hasta_20)
            self.renta_impo2 =  self.total_renta - self.renta_impo1
            self.renta_anual_2 = self.renta_impo2 * (@fives.tasa2 / 100 )
        else
            if self.total_renta > impo2_y_hasta_20 
                self.renta_impo2 = impo2_y_hasta_20 - self.renta_impo1
                self.renta_anual_2  = self.renta_impo2 * (@fives.tasa2 / 100)
            else 
                self.renta_impo2 = 0
                self.renta_anual_2  = self.renta_impo2 * (@fives.tasa2 / 100)
            end
        end
        
        if (self.total_renta > impo3_exceso_20 and self.total_renta <= impo3_y_hasta_35)
            
            self.renta_impo3 = self.total_renta - self.renta_impo1 - self.renta_impo2
            self.renta_anual_3 = self.renta_impo3 * (@fives.tasa4 / 100 )
            
        else
            if self.total_renta > impo3_y_hasta_35 
                self.renta_impo3  = impo3_y_hasta_35 - self.renta_impo1 - self.renta_impo2
                self.renta_anual_3 = self.renta_impo3 * (@fives.tasa4 / 100 )
            else 
                self.renta_impo3 = 0
                self.renta_anual_3 = self.renta_impo3 * (@fives.tasa4 / 100)
            end
        end
        
          
        if (self.total_renta > impo4_exceso_35 and self.total_renta <= impo4_y_hasta_45)
            self.renta_impo4 = self.total_renta - self.renta_impo1 - self.renta_impo2 - self.renta_impo3
            self.renta_anual_4 = self.renta_impo4 * (@fives.tasa6 / 100)
        else
            if self.total_renta > impo4_y_hasta_45 
                self.renta_impo4  = impo4_y_hasta_45 - self.renta_impo1 - self.renta_impo2 - self.renta_impo3
                self.renta_anual_4 = self.renta_impo4 * (@fives.tasa6 / 100)
            else 
                self.renta_impo4 = 0
                self.renta_anual_4 = self.renta_impo4 * (@fives.tasa6 / 100)
            end
        end
        if self.total_renta > impo5_exceso_45 
            self.renta_impo5 = total_renta - self.renta_impo1 - self.renta_impo2 - self.renta_impo3 - self.renta_impo4
            self.renta_anual_5 = self.renta_impo5* (@fives.tasa8 / 100)
        else
            self.renta_impo5 = 0
            self.renta_anual_5 = self.renta_impo5* (@fives.tasa8 / 100 )
        end 
        self.total_renta_impo = self.renta_anual_1+self.renta_anual_2+self.renta_anual_3+self.renta_anual_4+self.renta_anual_5      
        
        self.renta_impo_ret = self.total_renta_impo  - ( self.ene2 + self.feb2 + self.mar2 + self.abr2 + self.may2 + self.jun2 + self.jul2 + self.ago2 + self.set2 + self.oct2 + self.nov2 )
        
        if mes == 1 
            self.mes_pendiente = 12
        elsif(mes==2)
            self.mes_pendiente = 11
        elsif(mes==3)
            self.mes_pendiente = 10
        elsif(mes==4)
            self.mes_pendiente = 9
        elsif(mes==5)
            self.mes_pendiente = 8
        elsif(mes==6)
            self.mes_pendiente = 7
        elsif(mes==7)
            self.mes_pendiente = 6
        elsif(mes==8)
            self.mes_pendiente = 5
        elsif(mes==9)
            self.mes_pendiente = 4
        elsif(mes==10)
            self.mes_pendiente = 3
        elsif(mes==11)
            self.mes_pendiente = 2
        elsif(mes==12)
            self.mes_pendiente = 1
        
        end
        
        self.retencion_mensual = self.renta_impo_ret / self.mes_pendiente
        
    end 
end
