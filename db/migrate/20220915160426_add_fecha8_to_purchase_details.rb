class AddFecha8ToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :fecha8, :datetime
    add_column :purchase_details, :qty8, :float

    add_column :purchase_details, :fecha9, :datetime
    add_column :purchase_details, :qty9, :float

    add_column :purchase_details, :fecha10, :datetime
    add_column :purchase_details, :qty10, :float

  end
end
