class AddDateProcessedToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :date_processed, :datetime
  end
end
