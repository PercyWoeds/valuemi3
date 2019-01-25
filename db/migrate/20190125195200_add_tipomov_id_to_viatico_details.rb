class AddTipomovIdToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :tipomov_id, :integer
  end
end
