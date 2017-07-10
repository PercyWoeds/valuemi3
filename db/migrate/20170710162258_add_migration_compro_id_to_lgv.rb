class AddMigrationComproIdToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :compro_id, :integer
  end
end
