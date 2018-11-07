class AddTdToNoteConcepts < ActiveRecord::Migration
  def change
    
    add_column :note_concepts, :document_id, :integer
  end
end
