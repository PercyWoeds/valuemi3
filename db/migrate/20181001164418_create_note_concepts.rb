class CreateNoteConcepts < ActiveRecord::Migration
  def change
    create_table :note_concepts do |t|
      t.string :code
      t.string :descrip
      t.string :td

      t.timestamps null: false
    end
  end
end
