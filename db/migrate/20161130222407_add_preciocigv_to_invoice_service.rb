class AddPreciocigvToInvoiceService < ActiveRecord::Migration
  def change
    add_column :invoice_services, :preciocigv, :float
  end
end
