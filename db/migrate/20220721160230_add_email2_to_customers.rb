class AddEmail2ToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :email2, :string
  end
end
