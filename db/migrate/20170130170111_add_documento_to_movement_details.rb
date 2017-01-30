class AddDocumentoToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :documento, :string
  end
end
