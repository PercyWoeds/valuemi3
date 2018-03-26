class CreateTanques < ActiveRecord::Migration
  def change
    create_table :tanques do |t|
      t.string :code
      t.integer :product_id
      t.float :saldo_inicial
      t.float :varilla

      t.timestamps null: false
    end
  end
end
