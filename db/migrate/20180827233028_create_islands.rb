class CreateIslands < ActiveRecord::Migration
  def change
    create_table :islands do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
