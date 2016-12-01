class AddProcessedToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :processed, :string
  end
end
