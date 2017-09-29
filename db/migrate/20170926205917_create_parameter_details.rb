class CreateParameterDetails < ActiveRecord::Migration
  def change
    create_table :parameter_details do |t|
      t.integer :parameter_id
      t.integer :afp_id
      t.float :aporte
      t.float :seguro
      t.float :comision

      t.timestamps null: false
    end
  end
end
