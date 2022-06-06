class AddFechaParteToDepositos < ActiveRecord::Migration
  def change
    add_column :depositos, :fecha_parte, :datetime
  end
end
