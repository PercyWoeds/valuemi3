class AddRecibirToItems < ActiveRecord::Migration
  def change
    add_column :items, :recibir, :integer
  end
end
