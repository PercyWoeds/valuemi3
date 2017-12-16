class CreatePayrollbonis < ActiveRecord::Migration
  def change
    create_table :payrollbonis do |t|
      t.string :code
      t.string :descrip
      t.float :importe

      t.timestamps null: false
    end
  end
end
