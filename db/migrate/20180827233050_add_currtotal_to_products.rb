class AddCurrtotalToProducts < ActiveRecord::Migration
  def change
    add_column :products, :currtotal, :float
  end
end
