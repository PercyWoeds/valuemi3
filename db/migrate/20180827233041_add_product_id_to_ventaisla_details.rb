class AddProductIdToVentaislaDetails < ActiveRecord::Migration
  def change
    add_column :ventaisla_details, :product_id, :integer
  end
end
