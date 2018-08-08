class AddCostoIngresoToMovementPay < ActiveRecord::Migration
  def change
    add_column :movement_pays, :costo_ingreso, :float
    add_column :movement_pays, :costo_salida, :float
    add_column :movement_pays, :costo_saldo, :float
  end
end
