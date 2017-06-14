class AddCurrTotalToCompro < ActiveRecord::Migration
  def change
    add_column :compros, :CurrTotal, :float
  end
end
