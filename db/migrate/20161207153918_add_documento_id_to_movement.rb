class AddDocumentoIdToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :documento, :string
  end
end
