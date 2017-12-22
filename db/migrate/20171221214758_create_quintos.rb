class CreateQuintos < ActiveRecord::Migration
  def change
    create_table :quintos do |t|
      t.integer :anio
      t.integer :employee_id
      t.integer :mes
      t.float  :rem_actual
      t.float :rem_mes
      t.float :asignacion
      t.float :hextras
      t.float :otros1
      t.integer :mes_proy
      t.float :rem_proyectada
      t.float :gratijulio
      t.float :gratidic
      t.float :bonextra
      t.float :otros2
      t.float :ene1
      t.float :feb1
      t.float :mar1
      t.float :abr1
      t.float :may1
      t.float :jun1
      t.float :jul1
      t.float :ago1
      t.float :set1
      t.float :oct1
      t.float :nov1
      t.float :renta_bruta
      t.float :deduccion7
      t.float :total_renta
      t.float :renta_impo1
      t.float :renta_impo2
      t.float :renta_impo3
      t.float :renta_impo4
      t.float :renta_impo5
      t.float :total_renta_impo
      t.float :ene2
      t.float :feb2
      t.float :mar2
      t.float :abr2
      t.float :may2
      t.float :jun2
      t.float :jul2
      t.float :ago2
      t.float :set2
      t.float :oct2
      t.float :nov2
      t.float :dic2
      t.float :renta_impo_ret
      t.integer :mes_pendiente
      t.float :retencion_mensual

      t.timestamps null: false
    end
  end
end
