class AddCsubtotalToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :csubtotal, :float
  end
end
