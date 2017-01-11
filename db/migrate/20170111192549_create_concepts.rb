class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
      t.string :descrip
      t.string :code

      t.timestamps null: false
    end
  end
end
