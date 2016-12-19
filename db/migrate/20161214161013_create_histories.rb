class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|

    	t.integer  :user_id
	    t.integer  :historiable_id
	    t.boolean  :new_item,         default: false
	    t.string   :historiable_type
	    
	    t.datetime :created_at
	    t.string   :klass_type
	    

      t.timestamps null: false
    end


  add_index :histories, :created_at
  add_index :histories, :historiable_id
  add_index :histories, :user_id

  end
end
