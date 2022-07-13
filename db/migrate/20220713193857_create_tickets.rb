class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :code
      t.datetime :fecha
      t.float :cantidad

      t.timestamps null: false
    end
  end
end
