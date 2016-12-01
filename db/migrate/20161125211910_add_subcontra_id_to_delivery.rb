class AddSubcontraIdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :subcontrat_id, :integer
  end
end
