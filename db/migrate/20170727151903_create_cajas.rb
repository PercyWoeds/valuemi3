class CreateCajas < ActiveRecord::Migration
  def change
    create_table :cajas do |t|
      t.string :descrip
      t.float :inicial

      t.timestamps null: false
    end
  end
end
