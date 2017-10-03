class CreateValors < ActiveRecord::Migration
  def change
    create_table :valors do |t|
      t.string :name
      t.text :comments

      t.timestamps null: false
    end
  end
end
