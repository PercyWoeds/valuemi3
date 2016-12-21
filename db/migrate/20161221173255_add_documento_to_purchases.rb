class AddDocumentoToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :documento, :string
  end
end
