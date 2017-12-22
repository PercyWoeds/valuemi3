class AddRentaAnual1ToQuintos < ActiveRecord::Migration
  def change
    add_column :quintos, :renta_anual_1, :float
    add_column :quintos, :renta_anual_2, :float
    add_column :quintos, :renta_anual_3, :float
    add_column :quintos, :renta_anual_4, :float
    add_column :quintos, :renta_anual_5, :float
  end
end
