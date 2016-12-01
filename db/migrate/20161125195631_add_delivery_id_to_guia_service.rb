class AddDeliveryIdToGuiaService < ActiveRecord::Migration
  def change
    add_column :guia_services, :Delivery_id, :integer
  end
end
