class AddTotalToService < ActiveRecord::Migration
  def change
    add_column :services, :total, :float
  end
end
