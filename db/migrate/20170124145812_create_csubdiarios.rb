class CreateCsubdiarios < ActiveRecord::Migration
  def change
    create_table :csubdiarios do |t|
      t.string :csubdia
      t.string :ccompro
      t.string :ccodmon
      t.string :csitua
      t.string :ctipcam
      t.string :cglosa
      t.float :ctotal
      t.string :ctipo
      t.string :cflag
      t.string :cdate
      t.string :chora
      t.string :cfeccam
      t.string :cuser
      t.string :corig
      t.string :cform
      t.string :cextor

      t.timestamps null: false
    end
  end
end
