class CreateUnidads < ActiveRecord::Migration
  def change
    create_table :unidads do |t|
      t.string :descrip
      t.float :valorconversion

      t.timestamps null: false
    end
  end
end
