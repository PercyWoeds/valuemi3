class AddDocumentIdToNoteCocept < ActiveRecord::Migration
  def change
    add_column :note_cocepts, :document_id, :integer
  end
end
