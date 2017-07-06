class AddGastoIdToLgvs < ActiveRecord::Migration
  def change
    add_column :lgvs, :gasto_id, :integer
  end
end
