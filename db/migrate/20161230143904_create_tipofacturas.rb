class CreateTipofacturas < ActiveRecord::Migration
  def change
    create_table :tipofacturas do |t|
      t.string :descrip

      t.timestamps null: false
    end
  end
end
