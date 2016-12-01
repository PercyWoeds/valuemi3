class RemoveDivisionIdToDelivery < ActiveRecord::Migration
  def change
    remove_column :deliveries, :division_id_integer, :integer
  end
end
