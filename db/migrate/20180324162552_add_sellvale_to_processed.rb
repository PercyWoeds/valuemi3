class AddSellvaleToProcessed < ActiveRecord::Migration
  def change
    add_column :sellvales, :processed, :string
  end
end
