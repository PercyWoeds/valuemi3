class AddParticipacionToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :participacion, :float
  end
end
