class AddGratijulio1ToQuintos < ActiveRecord::Migration
  def change
    add_column :quintos, :gratijulio1, :float
  end
end
