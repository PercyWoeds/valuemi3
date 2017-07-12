class AddTranportorderIdToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :tranportorder_id, :integer
  end
end
