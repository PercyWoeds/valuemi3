class CreateMovementDetails < ActiveRecord::Migration
  def change
    create_table :movement_details do |t|

	    t.integer  :account_id
	    t.integer  :item_id
	    t.decimal  :quantity,       precision: 14, scale: 2, default: 0.0
	    t.decimal  :price,          precision: 14, scale: 2, default: 0.0
	    t.string   :description
	    t.decimal  :discount,       precision: 14, scale: 2, default: 0.0
	    t.decimal  :balance,        precision: 14, scale: 2, default: 0.0
	    t.decimal  :original_price, precision: 14, scale: 2, default: 0.0
	    t.datetime :created_at,                                            null: false
	    t.datetime :updated_at,                                            null: false

        t.timestamps null: false
    end

	add_index :movement_details, :account_id
  	add_index :movement_details, :item_id

  end
end
