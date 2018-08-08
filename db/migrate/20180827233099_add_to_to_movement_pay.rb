class AddToToMovementPay < ActiveRecord::Migration
  def change
    add_column :movement_pays, :to, :integer
  end
end
