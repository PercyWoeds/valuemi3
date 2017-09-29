class CreateTempfacturas < ActiveRecord::Migration
  def change
    create_table :tempfacturas do |t|
        t.integer :customer_id
        t.float :year_month
        t.float :balance 

      t.timestamps null: false
    end
  end
end
