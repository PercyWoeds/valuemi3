class AddInstruccionIdToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :instruccion_id, :integer
  end
end
