class AddNumeroToCaja < ActiveRecord::Migration
  def change
    add_column :cajas, :numero, :string
  end
end
