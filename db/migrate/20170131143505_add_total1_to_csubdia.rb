class AddTotal1ToCsubdia < ActiveRecord::Migration
  def change
    add_column :csubdia, :total1, :float
  end
end
