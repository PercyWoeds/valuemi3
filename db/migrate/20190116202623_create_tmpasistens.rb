class CreateTmpasistens < ActiveRecord::Migration
  def change
    create_table :tmpasistens do |t|
      t.integer :dia_month
      t.string :cod_emp
      t.integer :turno

      t.timestamps null: false
    end
  end
end
