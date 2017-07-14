class AddCoproIdToLgvDelivery < ActiveRecord::Migration
  def change
    add_column :lgv_deliveries, :compro_id, :integer
  end
end
