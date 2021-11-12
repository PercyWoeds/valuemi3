class AddQtyToDevols < ActiveRecord::Migration
  def change
    add_column :devols, :qty, :float
  end
end
