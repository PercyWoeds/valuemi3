class AddCcodaneToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :ccodane, :string
  end
end
