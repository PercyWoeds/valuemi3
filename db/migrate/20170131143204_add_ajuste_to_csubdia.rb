class AddAjusteToCsubdia < ActiveRecord::Migration
  def change
    add_column :csubdia, :ajuste, :float
  end
end
