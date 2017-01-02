class AddDate3ToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :date3, :datetime
  end
end
