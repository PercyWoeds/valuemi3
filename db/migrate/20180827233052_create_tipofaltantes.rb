class CreateTipofaltantes < ActiveRecord::Migration
  def change
    create_table :tipofaltantes do |t|
      t.string :code
      t.string :descrip
      t.float  :importe
      
      t.timestamps null: false
    end
  end
end
