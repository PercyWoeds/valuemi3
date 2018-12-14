class AddDocumentoToTirad < ActiveRecord::Migration
  def change
    add_column :tirads, :documento, :string
    add_column :tirads, :moneda, :string
    add_column :tirads, :isla, :string
    add_column :tirads, :autoriza, :string
    
  end
end
