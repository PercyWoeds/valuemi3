class AddAddres2idToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :address2_id, :integer
  end
end
