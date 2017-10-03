class CreateOcupacions < ActiveRecord::Migration
  def change
    create_table :ocupacions do |t|
    
      t.integer :code
      t.string  :name

      t.timestamps null: false
    end
  end
end
