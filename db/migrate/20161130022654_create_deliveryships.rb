class CreateDeliveryships < ActiveRecord::Migration
  def change
    create_table :deliveryships do |t|
      t.belongs_to :factura
      t.belongs_to :delivery

      t.timestamps null: false
    end
  end
end
