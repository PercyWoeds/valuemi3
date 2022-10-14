class AddRazonSocialToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :razon_social, :string
    add_column :markets, :address, :string
  end
end
