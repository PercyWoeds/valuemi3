class AddMostRecentReportToUser < ActiveRecord::Migration
  def change
    add_column :users, :most_recent_report, :string
  end
end
