class AddPreciocigvToInvoicesunats < ActiveRecord::Migration
  def change
    add_column :invoicesunats, :preciocigv, :float
  end
end
