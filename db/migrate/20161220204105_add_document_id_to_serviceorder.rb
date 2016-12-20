class AddDocumentIdToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :document_id, :integer
  end
end
