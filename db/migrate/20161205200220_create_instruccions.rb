class CreateInstruccions < ActiveRecord::Migration
  def change
    create_table :instruccions do |t|
      t.text :description1
      t.text :description2
      t.text :description3
      t.text :description4

      t.timestamps null: false
    end
  end
end
