class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :code
      t.datetime :fecha
      t.float :onp
      t.float :sctr_1
      t.float :sctr_2
      t.float :essalud

      t.timestamps null: false
    end
  end
end
