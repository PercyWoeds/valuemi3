class AddRucToMarket < ActiveRecord::Migration
  def change

    add_column :markets, :razon_social
    add_column :markets, :address 
    
  end
end
