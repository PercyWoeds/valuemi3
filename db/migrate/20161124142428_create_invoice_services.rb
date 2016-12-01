class CreateInvoiceServices < ActiveRecord::Migration
  def change
    create_table :invoice_services do |t|
      t.integer :invoice2_id
      t.integer :service_id
      t.float :price
      t.integer :quantity
      t.float :discount
      t.float :total

      t.timestamps null: false
    end
  end
end
