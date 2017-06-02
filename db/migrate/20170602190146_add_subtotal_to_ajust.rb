class AddSubtotalToAjust < ActiveRecord::Migration
  def change
    add_column :ajusts, :subtotal, :float
  end
end
