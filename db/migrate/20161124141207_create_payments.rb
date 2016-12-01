class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :descrip
      t.text :comment
      t.integer :day

      t.timestamps null: false
    end
  end
end
