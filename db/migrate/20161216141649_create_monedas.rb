class CreateMonedas < ActiveRecord::Migration
  def change
    create_table :monedas do |t|

      t.timestamps null: false
    end
  end
end
