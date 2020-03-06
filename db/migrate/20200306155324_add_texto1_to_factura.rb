class AddTexto1ToFactura < ActiveRecord::Migration
  def change

    add_column :facturas, :texto1, :string
    add_column :facturas, :texto2, :string
    add_column :facturas, :texto3, :string
    

  end
end
