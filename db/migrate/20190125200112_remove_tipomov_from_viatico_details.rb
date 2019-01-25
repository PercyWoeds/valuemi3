class RemoveTipomovFromViaticoDetails < ActiveRecord::Migration
  def change
    remove_column :viatico_details, :tipomov, :integer
  end
end
