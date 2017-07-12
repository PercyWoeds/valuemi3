class AddFechaToTranportorder < ActiveRecord::Migration
  def change
    add_column :tranportorders, :fecha, :datetime
  end
end
