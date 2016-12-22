class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :phone1
      t.string :email

      t.timestamps null: false
    end
  end
end
