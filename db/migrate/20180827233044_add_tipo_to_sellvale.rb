class AddTipoToSellvale < ActiveRecord::Migration
  def change
    add_column :sellvales, :tipo, :string
  end
end
