class AddCurrTotalToProducts < ActiveRecord::Migration
  def change
    add_column :products, :CurrTotal, :float
  end
end
