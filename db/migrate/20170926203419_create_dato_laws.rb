class CreateDatoLaws < ActiveRecord::Migration
  def change
    create_table :dato_laws do |t|
      t.integer :employee_id
      t.string :sueldo_integral
      t.string :comision
      t.string :descuento_ley
      t.integer :afp_id
      t.string :ies
      t.string :senati
      t.string :sobretiempo
      t.string :otra_ley_social
      t.string :accidente_trabajo
      t.string :descuento_quinta
      t.string :domiciliado
      t.string :a_familiar
      t.string :no_afecto
      t.string :no_afecto_grati
      t.string :no_afecto_afp
      t.string :cussp
      t.string :tipo_afiliado_id
      t.string :regimen_id
      t.datetime :contrato_inicio
      t.datetime :contrato_fin
      t.datetime :vacaciones_inicio
      t.datetime :vacaciones_fin
      t.float :grati_julio
      t.float :grati_diciembre
      t.float :importe_subsidio

      t.timestamps null: false
    end
  end
end
