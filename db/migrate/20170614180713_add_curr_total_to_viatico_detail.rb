class AddCurrTotalToViaticoDetail < ActiveRecord::Migration
  def change
    add_column :viatico_details, :CurrTotal, :float
  end
end
