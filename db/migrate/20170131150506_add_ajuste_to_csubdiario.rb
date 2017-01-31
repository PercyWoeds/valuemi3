class AddAjusteToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :ajuste, :float
  end
end
