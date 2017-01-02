class AddDescripshortToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :descripshort, :string
  end
end
