class AddDateProcessedToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :date_processed, :datetime
  end
end
