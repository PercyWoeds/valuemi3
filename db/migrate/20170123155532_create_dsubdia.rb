class CreateDsubdia < ActiveRecord::Migration
  def change
    create_table :dsubdia do |t|
      t.string :dcompro
      t.string :dsecue
      t.string :dfeccom
      t.string :dcuenta
      t.string :dcodane
      t.string :dcencos
      t.string :dcodmon
      t.string :ddh
      t.float :dimport
      t.string :dtipdoc
      t.string :dnumdoc
      t.string :dfecdoc
      t.string :dfecven
      t.string :darea
      t.string :dflag
      t.string :dxglosa
      t.datetime :ddate
      t.string :dcodane2
      t.float :dusimpor
      t.float :dmnimpor
      t.string :dcodarc
      t.string :dtidref
      t.string :dndoref
      t.datetime :dfecref
      t.datetime :dbimref
      t.float :digvref

      t.timestamps null: false
    end
  end
end
