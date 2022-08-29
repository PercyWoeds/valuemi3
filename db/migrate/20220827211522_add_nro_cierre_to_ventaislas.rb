class AddNroCierreToVentaislas < ActiveRecord::Migration
  def change
    add_column :ventaislas, :nro_cierre, :integer
  end
end
