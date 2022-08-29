class AddDTotImporteToTmpContometros < ActiveRecord::Migration
  def change
    add_column :tmp_contometros, :d_tot_importe, :float
  end
end
