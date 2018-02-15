class CreateDestinos < ActiveRecord::Migration
  def change
    create_table :destinos do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
