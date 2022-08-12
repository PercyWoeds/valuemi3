class AddQty1ToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :fecha1, :datetime
    add_column :purchase_details, :qty1, :float
    
    add_column :purchase_details, :fecha2, :datetime
    add_column :purchase_details, :qty2, :float

    add_column :purchase_details, :fecha3, :datetime
    add_column :purchase_details, :qty3, :float

    add_column :purchase_details, :fecha4, :datetime
    add_column :purchase_details, :qty4, :float


  end
end
