class AddTipoToVentaislas < ActiveRecord::Migration
  def change
    add_column :ventaislas, :tipo, :integer
  end
end
