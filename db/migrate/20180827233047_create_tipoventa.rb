class CreateTipoventa < ActiveRecord::Migration
  def change
    create_table :tipoventa do |t|
      t.string :code
      t.string :nombre

      t.timestamps null: false
    end
  end
end
