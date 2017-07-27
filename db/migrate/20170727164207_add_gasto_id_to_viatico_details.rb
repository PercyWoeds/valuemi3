class AddGastoIdToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :gasto_id, :integer
  end
end
