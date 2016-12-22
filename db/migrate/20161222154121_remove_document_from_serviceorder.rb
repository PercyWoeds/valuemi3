class RemoveDocumentFromServiceorder < ActiveRecord::Migration
  def change
    remove_column :serviceorders, :document, :string
  end
end
