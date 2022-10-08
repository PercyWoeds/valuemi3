class AddFecha2ToViaticoDetail < ActiveRecord::Migration
  def change
    add_column :viatico_details, :fecha2, :datetime
  end
end
