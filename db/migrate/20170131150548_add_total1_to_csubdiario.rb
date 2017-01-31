class AddTotal1ToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :total1, :float
  end
end
