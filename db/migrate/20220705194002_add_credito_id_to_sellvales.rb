class AddCreditoIdToSellvales < ActiveRecord::Migration
  def change
    add_column :sellvales, :credito_id, :integer
  end
end
