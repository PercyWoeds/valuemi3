class RemovePesoFromService < ActiveRecord::Migration
  def change
    remove_column :services, :peso, :string
  end
end
