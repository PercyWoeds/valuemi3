class CreateSubcontrats < ActiveRecord::Migration
  def change
    create_table :subcontrats do |t|
      t.string :ruc
      t.string :name
      t.string :address1
      t.string :distrito
      t.string :provincia
      t.string :dpto
      t.string :pais

      t.timestamps null: false
    end
  end
end
