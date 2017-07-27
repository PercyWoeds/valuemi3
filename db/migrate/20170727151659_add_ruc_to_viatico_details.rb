class AddRucToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :ruc, :string
  end
end
