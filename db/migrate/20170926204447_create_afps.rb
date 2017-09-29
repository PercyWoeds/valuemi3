class CreateAfps < ActiveRecord::Migration
  def change
    create_table :afps do |t|
      t.string :name
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
