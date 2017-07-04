class AddComments1ToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :comments, :text
  end
end
