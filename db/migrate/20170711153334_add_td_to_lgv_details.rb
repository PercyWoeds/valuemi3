class AddTdToLgvDetails < ActiveRecord::Migration
  def change
    add_column :lgv_details, :td, :string
  end
end
