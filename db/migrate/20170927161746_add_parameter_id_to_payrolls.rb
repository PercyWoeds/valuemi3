class AddParameterIdToPayrolls < ActiveRecord::Migration
  def change
    add_column :payrolls, :parameter_id, :integer
  end
end
