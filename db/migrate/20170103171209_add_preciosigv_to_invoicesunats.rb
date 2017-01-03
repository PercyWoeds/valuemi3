class AddPreciosigvToInvoicesunats < ActiveRecord::Migration
  def change
    add_column :invoicesunats, :preciosigv, :float
  end
end
