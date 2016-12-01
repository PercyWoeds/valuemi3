class AddUnidadToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :unidad, :text
  end
end
