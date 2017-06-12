class AddCommentsToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :comments, :string
  end
end
