class AddDestinoIdToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :destino_id, :integer
  end
end
