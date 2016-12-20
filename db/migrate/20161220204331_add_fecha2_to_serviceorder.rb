class AddFecha2ToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :fecha2, :datetime
  end
end
