class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|

        t.integer :contact_id
        t.integer :store_id
        t.integer :account_id

        t.date   :date
        t.string :ref_number
        t.string :operation, :limit => 10
        t.string :state

        t.string :description

        t.decimal :total, :precision => 14, :scale => 2, default: 0

        t.integer  :creator_id
        t.integer  :transference_id
        t.integer  :store_to_id
        t.integer  :project_id

        t.boolean :has_error, default: false
        t.string  :error_messages
    	t.integer  :updater_id


        t.timestamps
      end
      
      add_index :inventories, :contact_id
      add_index :inventories, :store_id
      add_index :inventories, :account_id
      add_index :inventories, :project_id

      add_index :inventories, :date
      add_index :inventories, :ref_number
      add_index :inventories, :operation
      add_index :inventories, :state
      add_index :inventories, :has_error
  

  end
end


