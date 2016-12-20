class AddDocumentToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :document, :string
  end
end
