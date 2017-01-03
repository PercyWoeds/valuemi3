class RemovePreciosigvFromInvoicesunats < ActiveRecord::Migration
  def change
    remove_column :invoicesunats, :preciosigv, :decimal
  end
end
