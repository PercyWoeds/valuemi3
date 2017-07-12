class AddIToTranportorder < ActiveRecord::Migration
  def change
    add_column :tranportorders, :i, :integer
    add_column :tranportorders, :tm, :string
    add_column :tranportorders, :comprobante, :string
    add_column :tranportorders, :importe, :float
    add_column :tranportorders, :detalle, :string
    add_column :tranportorders, :CurrTotal, :float
    
  end
end
