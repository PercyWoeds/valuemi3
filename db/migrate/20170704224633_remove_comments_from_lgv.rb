class RemoveCommentsFromLgv < ActiveRecord::Migration
  def change
    remove_column :lgvs, :comments, :integer
  end
end
