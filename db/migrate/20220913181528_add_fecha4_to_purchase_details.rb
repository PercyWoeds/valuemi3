class AddFecha4ToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :fecha5, :datetime
    add_column :purchase_details, :qty5, :float


    add_column :purchase_details, :fecha6, :datetime
    add_column :purchase_details, :qty6, :float

    add_column :purchase_details, :fecha7, :datetime
    add_column :purchase_details, :qty7, :float

 


  end
end
