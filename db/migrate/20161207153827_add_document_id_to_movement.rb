class AddDocumentIdToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :document_id, :integer
  end
end
