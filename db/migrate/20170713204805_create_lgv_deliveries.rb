class CreateLgvDeliveries < ActiveRecord::Migration
  def change
    create_table :lgv_deliveries do |t|
      t.integer :lgv_id
      t.float :importe

      t.timestamps null: false
    end
  end
end
