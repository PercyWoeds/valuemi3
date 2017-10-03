class CreateTipotrabajadors < ActiveRecord::Migration
  def change
    create_table :tipotrabajadors do |t|
      t.integer :code
      t.string  :name

      t.timestamps null: false
    end
  end
end
