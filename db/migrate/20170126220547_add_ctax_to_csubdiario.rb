class AddCtaxToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :ctax, :float
  end
end
