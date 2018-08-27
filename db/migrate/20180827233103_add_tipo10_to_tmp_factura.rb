class AddTipo10ToTmpFactura < ActiveRecord::Migration
  def change
    add_column :tmp_facturas, :tipo10, :string
  end
end
