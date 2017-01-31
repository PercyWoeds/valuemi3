class AddFactoryToCsubdia < ActiveRecord::Migration
  def change
    add_column :csubdia, :factory, :float
  end
end
