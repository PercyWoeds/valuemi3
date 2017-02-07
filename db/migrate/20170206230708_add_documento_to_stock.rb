class AddDocumentoToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :documento, :string
  end
end
