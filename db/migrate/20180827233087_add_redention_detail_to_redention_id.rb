class AddRedentionDetailToRedentionId < ActiveRecord::Migration
  def change
    add_column :redention_details, :redention_id, :integer
  end
end
