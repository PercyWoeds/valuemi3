class AddComproIdToViatico < ActiveRecord::Migration
  def change
    add_column :viaticos, :compro_id, :integer
  end
end
