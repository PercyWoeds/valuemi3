class CreateCategoria < ActiveRecord::Migration
  def change
    create_table :categoria do |t|
      t.string :code
      t.string :descrip
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
