class AddNoteConceptIdToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :note_concept_id, :integer
  end
end
