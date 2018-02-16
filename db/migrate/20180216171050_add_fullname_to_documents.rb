class AddFullnameToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :fullname, :string
  end
end
