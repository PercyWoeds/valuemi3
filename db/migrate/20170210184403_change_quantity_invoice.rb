class ChangeQuantityInvoice < ActiveRecord::Migration
  def change
  	change_column :invoice_services, :quantity, :float
  	
  end
end
