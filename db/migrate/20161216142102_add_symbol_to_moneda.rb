class AddSymbolToMoneda < ActiveRecord::Migration
  def change
    add_column :monedas, :symbol, :string
  end
end
