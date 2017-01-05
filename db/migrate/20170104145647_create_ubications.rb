class CreateUbications < ActiveRecord::Migration
  def change
    create_table :ubications do |t|
      t.string :descrip
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
