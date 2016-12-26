class CreatePurchaseships < ActiveRecord::Migration
  def change
    create_table :purchaseships do |t|
      t.integer :serviceorder_id
      t.integer :purchase_id

      t.timestamps null: false
    end
  end
end
