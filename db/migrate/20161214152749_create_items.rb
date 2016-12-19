class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|

  		t.integer :unit_id
        t.decimal :price, precision: 14, scale: 2, default: 0.0
        t.string  :name
        t.string  :description
        t.string  :code, :limit => 100
        t.boolean :for_sale, :default => true
        t.boolean :stockable, :default => true
        t.boolean :active, :default => true
		t.decimal  :buy_price,               precision: 14, scale: 2, default: 0.0
	    t.string   :unit_symbol, limit: 20
	    t.string   :unit_name
	    t.integer  :tag_ids,                                          default: [],                array: true
	    t.integer  :updater_id
	    t.integer  :creator_id        

        t.timestamps
      end


		  add_index :items, :code
		  add_index :items, :creator_id
		  add_index :items, :for_sale
		  add_index :items, :stockable
		  add_index :items, :tag_ids
		  add_index :items, :unit_id
		  add_index :items, :updater_id

      
  end
end


	