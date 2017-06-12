class AddProcessedToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :processed, :string
  end
end
