class AddNumberToRedentions < ActiveRecord::Migration
  def change
    add_column :redentions, :number, :string
  end
end
