class AddStateToRedention < ActiveRecord::Migration
  def change
    add_column :redentions, :state, :string
  end
end
