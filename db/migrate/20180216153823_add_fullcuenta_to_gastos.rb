class AddFullcuentaToGastos < ActiveRecord::Migration
  def change
    add_column :gastos, :fullcuenta, :string
  end
end
