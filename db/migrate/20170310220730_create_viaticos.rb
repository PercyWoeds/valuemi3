class CreateViaticos < ActiveRecord::Migration
  def change
    create_table :viaticos do |t|
      t.string :code
      t.datetime :fecha1
      t.float :inicial
      t.float :total_ing
      t.float :total_egreso
      t.float :saldo

      t.timestamps null: false
    end
  end
end
