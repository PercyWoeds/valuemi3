class CreateUbicas < ActiveRecord::Migration
  def change
    create_table :ubicas do |t|
      t.string :descrip
      t.text :comments

      t.timestamps null: false
    end
  end
end
