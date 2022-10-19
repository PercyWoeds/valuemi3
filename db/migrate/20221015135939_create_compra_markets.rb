class CreateCompraMarkets < ActiveRecord::Migration
  def change
    create_table :compra_markets do |t|
      t.string :order_id 
      t.string :cod_prod
      t.float :precio_uni 
      t.float :cantidad
      t.string :tipdoc 
      t.string :numdoc 
      t.string :moneda 
      t.datetime  :fecha
      t.float   :mes
      t.string :cod_prov 
      t.float :descuento
      t.float :preciosigv 
      t.float :preciopps 
      t.float :preciocigv 
      t.float :margen 
      t.float :preciopp
      t.float :importe 
      t.float :importe_conv
      t.float :igv 
      t.float :igv_conv
      t.float :total
      t.float :total_conv
      t.float :impuesto
      t.string :cod_emp
      t.string :estado
      t.string :precioimpr
      t.float  :cambio
      t.string :cod_dep
      t.string :name
      t.string :name2
      t.string :archivo 
      t.string :observaciones  
      
      t.timestamps null: false

    end
  end
end
