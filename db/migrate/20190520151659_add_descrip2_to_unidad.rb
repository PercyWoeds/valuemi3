class AddDescrip2ToUnidad < ActiveRecord::Migration
  def change
    add_column :unidads, :descrip2, :string
  end
end
