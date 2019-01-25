class AddComproToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :compro, :string
  end
end
