class CreateMovementPays < ActiveRecord::Migration
  def change
    create_table :movement_pays do |t|
      t.integer :customer_id
      t.float :inicial
      t.float :abono
      t.float :cargo
      t.float :saldo
      t.integer :document_id
      t.string :code
      t.string :description

      t.timestamps null: false
    end
  end
end
