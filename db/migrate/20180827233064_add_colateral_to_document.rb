class AddColateralToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :colateral, :string
  end
end
