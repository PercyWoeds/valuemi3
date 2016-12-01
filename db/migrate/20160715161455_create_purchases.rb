class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :tank_id
      t.string :integer
      t.integer :document_type_id
      t.string :document
      t.datetime :date1
      t.datetime :date2
      t.float :exchange
      t.integer :product_id
      t.integer :unit_id
      t.float :price_with_tax
      t.float :price_without_tax
      t.float :price_public
      t.float :quantity
      t.integer :other
      t.string :money_type
      t.float :discount
      t.float :tax1
      t.float :payable_amount
      t.float :tax_amount
      t.float :total_amount
      t.string :status
      t.string :pricestatus
      t.float :charge
      t.float :payment
      t.float :balance
      t.float :tax2
      t.integer :supplier_id
      t.string :order1
      t.integer :plate_id
      t.integer :user_id
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.text :comments

      t.timestamps null: false
    end
  end
end
