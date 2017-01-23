class CreateCsubdia < ActiveRecord::Migration
  def change
    create_table :csubdia do |t|
      t.string :ccompro
      t.string :cfeccom
      t.string :ccodmon
      t.string :csitua
      t.float :ctipcam
      t.string :cglosa
      t.float :ctotal
      t.string :ctipo
      t.string :cflag
      t.datetime :cdate
      t.string :chora
      t.string :cfeccam
      t.string :cuser
      t.string :corig
      t.string :cform
      t.string :ctipo
      t.string :cextor

      t.timestamps null: false
    end
  end
end
