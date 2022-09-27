class AddMsgerrorToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :msgerror, :text
  end
end
