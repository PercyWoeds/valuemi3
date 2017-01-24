class CreateDsubdiarios < ActiveRecord::Migration
  def change
    create_table :dsubdiarios do |t|
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
      t.string :ddate
      t.string :dcodane2
      t.string :dusimpor
      t.string :dmnimpor
      t.string :dcodarc
      t.string :dtidref
      t.string :dndoref
      t.string :dfecref
      t.string :dbimref
      t.string :digvref

      t.timestamps null: false
    end
  end
end
