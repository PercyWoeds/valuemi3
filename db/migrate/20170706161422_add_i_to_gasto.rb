class AddIToGasto < ActiveRecord::Migration
  def change
    add_column :gastos, :i, :integer
    add_column :gastos, :fecha, :datetime
    add_column :gastos, :td, :string
    add_column :gastos, :documento, :string
    add_column :gastos, :importe, :float 
    add_column :gastos, :currtotal, :float 
  end
end
