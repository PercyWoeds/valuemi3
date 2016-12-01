class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :firstname
      t.string :lastname
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone1
      t.string :phone2
      t.string :email1
      t.string :email2
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
