class CreateAccounts < ActiveRecord::Migration
  def change

    create_table :accounts do |t|

		t.string  :name
        t.string  :currency, limit: 10
        t.decimal :exchange_rate, precision: 14, scale: 4, default: 1.0
        t.decimal :amount, precision: 14, scale: 2, default: 0.0
        t.string  :type, limit: 30

        t.integer :contact_id
        t.integer :project_id
        t.boolean :active, default: true
        t.string  :description, limit: 500
        t.date    :date
        t.string  :state, limit: 30
        t.boolean :has_error, default: false
        t.string  :error_messages, limit: 400

        t.integer  :tag_ids,  default: [], array: true
	    t.integer  :updater_id
	    t.decimal  :tax_percentage, precision: 5,  scale: 2, default: 0.0
	    t.integer  :tax_id
	    t.decimal  :total, precision: 14, scale: 2, default: 0.0
	    t.boolean  :tax_in_out, default: false
	    
	    t.integer  :creator_id
	    t.integer  :approver_id
	    t.integer  :nuller_id
	    t.date     :due_date

        t.timestamps
      end

      add_index :accounts, :active
	  add_index :accounts, :amount
	  add_index :accounts, :approver_id
	  add_index :accounts, :contact_id
	  add_index :accounts, :creator_id
	  add_index :accounts, :currency
	  add_index :accounts, :date
	  add_index :accounts, :description
	  add_index :accounts, :due_date
	  add_index :accounts, :extras
	  add_index :accounts, :has_error
	  add_index :accounts, :name
	  add_index :accounts, :nuller_id
	  add_index :accounts, :project_id
	  add_index :accounts, :state
	  add_index :accounts, :tag_ids
	  add_index :accounts, :tax_id
	  add_index :accounts, :tax_in_out
	  add_index :accounts, :type
	  add_index :accounts, :updater_id

  end
end
