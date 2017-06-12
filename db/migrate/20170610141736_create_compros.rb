class CreateCompros < ActiveRecord::Migration
  def change
    create_table :compros do |t|
      t.integer :ost_id
      t.datetime :fecha
      t.string :descrip
      t.integer :document_id
      t.string :numero
      t.float :importe
      t.text :detalle
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      
      t.timestamps null: false
    end
  end
end
