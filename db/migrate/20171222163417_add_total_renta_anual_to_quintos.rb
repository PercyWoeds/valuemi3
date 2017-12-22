class AddTotalRentaAnualToQuintos < ActiveRecord::Migration
  def change
    add_column :quintos, :total_renta_anual, :float
  end
end
