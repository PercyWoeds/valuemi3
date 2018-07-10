class AddPuntoToInvoiceProduct < ActiveRecord::Migration
  def change
    add_column :invoice_products, :punto, :integer
  end
end
