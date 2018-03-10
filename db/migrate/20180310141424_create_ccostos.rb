class CreateCcostos < ActiveRecord::Migration
  def change
    create_table :ccostos do |t|
      t.string :code
      t.string :name
      t.string :comments

      t.timestamps null: false
    end
  end
end
