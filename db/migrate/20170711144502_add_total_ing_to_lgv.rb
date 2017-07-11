class AddTotalIngToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :total_ing, :float
  end
end
