class AddDocumentoToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :documento, :string
  end
end
