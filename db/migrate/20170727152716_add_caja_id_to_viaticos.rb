class AddCajaIdToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :caja_id, :integer
  end
end
