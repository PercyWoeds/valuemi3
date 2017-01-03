class RemovePreciocigvFromInvoicesunats < ActiveRecord::Migration
  def change
    remove_column :invoicesunats, :preciocigv, :decimal
  end
end
