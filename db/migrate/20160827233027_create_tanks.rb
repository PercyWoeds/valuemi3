class CreateTanks < ActiveRecord::Migration
  def change
    create_table :tanks do |t|
      t.string :comments
      t.references :product, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
