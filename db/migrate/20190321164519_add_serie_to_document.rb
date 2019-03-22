class AddSerieToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :serie, :string
    add_column :documents, :numero, :string
  end
end
