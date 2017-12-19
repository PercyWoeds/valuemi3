class CreateTms < ActiveRecord::Migration
  def change
    create_table :tms do |t|
      t.string :code
      t.string :descrip

      t.timestamps null: false
    end
  end
end
