class AddDocumentIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :document_id, :integer
  end
end
