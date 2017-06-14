class AddIToCompro < ActiveRecord::Migration
  def change
    add_column :compros, :i, :integer
  end
end
