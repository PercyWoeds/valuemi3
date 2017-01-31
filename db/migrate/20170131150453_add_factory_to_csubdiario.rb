class AddFactoryToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :factory, :float
  end
end
