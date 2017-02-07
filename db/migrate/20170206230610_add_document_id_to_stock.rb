class AddDocumentIdToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :document_id, :integer
  end
end
