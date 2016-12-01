class AddDivisionIdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :division_id, :integer
  end
end
