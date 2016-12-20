class AddFecha3ToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :fecha3, :datetime
  end
end
