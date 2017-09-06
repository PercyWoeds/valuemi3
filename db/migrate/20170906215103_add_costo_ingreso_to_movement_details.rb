class AddCostoIngresoToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :costo_ingreso, :float
    add_column :movement_details, :costo_salida, :float
    add_column :movement_details, :costo_saldo, :float
  end
end
