class CreateCreditos < ActiveRecord::Migration
  def change
    create_table :creditos do |t|
      t.string :code
      t.string :nombre

      t.timestamps null: false
    end
  end
end
