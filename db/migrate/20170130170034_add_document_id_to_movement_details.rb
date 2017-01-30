class AddDocumentIdToMovementDetails < ActiveRecord::Migration
  def change
    add_column :movement_details, :document_id, :integer
  end
end
