class AddCommentsToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :comments, :integer
  end
end
