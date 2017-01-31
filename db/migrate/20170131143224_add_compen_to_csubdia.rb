class AddCompenToCsubdia < ActiveRecord::Migration
  def change
    add_column :csubdia, :compen, :float
  end
end
