class AddPesoToService < ActiveRecord::Migration
  def change
    add_column :services, :peso, :integer
  end
end
