class AddTipoToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :tipo, :string
  end
end
