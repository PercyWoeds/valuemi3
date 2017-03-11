class CreateViaticoDetails < ActiveRecord::Migration
  def change
    create_table :viatico_details do |t|
      t.integer :viatico_id
      t.datetime :fecha
      t.text :descrip
      t.integer :document_id
      t.string :numero
      t.float :importe
      t.text :detalle
      t.string :tm

      t.timestamps null: false
    end
  end
end
