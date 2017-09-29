class CreateTypePayrolls < ActiveRecord::Migration
  def change
    create_table :type_payrolls do |t|
      t.string :code
      t.string :descrip

      t.timestamps null: false
    end
  end
end
