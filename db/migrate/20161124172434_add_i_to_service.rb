class AddIToService < ActiveRecord::Migration
  def change
    add_column :services, :i, :integer
  end
end
