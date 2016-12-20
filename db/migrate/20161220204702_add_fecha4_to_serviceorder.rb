class AddFecha4ToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :fecha4, :datetime
  end
end
