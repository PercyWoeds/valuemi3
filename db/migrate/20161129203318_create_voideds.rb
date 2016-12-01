class CreateVoideds < ActiveRecord::Migration
  def change
    create_table :voideds do |t|
      t.string :serie
      t.string :numero
      t.string :texto

      t.timestamps null: false
    end
  end
end
