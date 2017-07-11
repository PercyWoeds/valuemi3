class AddPeajeToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :peaje, :float
  end
end
