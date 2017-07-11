class AddLgvIdToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :lgv_id, :integer
  end
end
