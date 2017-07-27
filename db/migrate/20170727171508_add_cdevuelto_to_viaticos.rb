class AddCdevueltoToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :cdevuelto , :string
    add_column :viaticos, :cdescuento, :string
    add_column :viaticos, :creembolso, :string
  end
end
