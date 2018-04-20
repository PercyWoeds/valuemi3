class AddTipoToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :tipo, :integer
  end
end
