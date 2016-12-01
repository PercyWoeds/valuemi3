class AddProcessedToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :processed, :string
  end
end
