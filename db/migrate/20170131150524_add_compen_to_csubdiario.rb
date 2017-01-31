class AddCompenToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :compen, :float
  end
end
