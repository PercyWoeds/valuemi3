class AddAccountToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :account, :string
  end
end
