class RemoveDocumentFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :document, :string
  end
end
