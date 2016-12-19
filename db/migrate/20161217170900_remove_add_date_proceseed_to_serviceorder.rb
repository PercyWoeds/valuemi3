class RemoveAddDateProceseedToServiceorder < ActiveRecord::Migration
  def change
    remove_column :serviceorders, :date_proceseed, :datetime
  end
end
