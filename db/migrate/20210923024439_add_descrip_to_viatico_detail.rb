class AddDescripToViaticoDetail < ActiveRecord::Migration
  def change
    add_column :viatico_details, :descrip, :string
  end
end
