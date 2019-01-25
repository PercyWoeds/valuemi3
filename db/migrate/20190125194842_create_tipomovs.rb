class CreateTipomovs < ActiveRecord::Migration
  def change
    create_table :tipomovs do |t|
      t.string :code
      t.string :descrip

      t.timestamps null: false
    end
  end
end
