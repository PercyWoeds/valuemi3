class AddTiposunatToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :tiposunat, :string
  end
end
