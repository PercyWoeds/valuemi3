class CreateNumeras < ActiveRecord::Migration
  def change
    create_table :numeras do |t|
      t.string :subdiario
      t.string :compro

      t.timestamps null: false
    end
  end
end
