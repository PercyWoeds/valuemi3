class AddTranportorderIdToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :tranporterorder_id, :integer
  end
end
