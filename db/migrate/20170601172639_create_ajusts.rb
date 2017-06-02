class CreateAjusts < ActiveRecord::Migration
  def change
    create_table :ajusts do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.text :description
      t.text :comments
      t.datetime :fecha1
      t.string :code
      t.float :total
      t.string :processed
      t.string :return
      t.datetime :date_processed
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
