class AddTipomovToViaticoDetail < ActiveRecord::Migration
  def change
    add_column :viatico_details, :tipomov, :string
  end
end
