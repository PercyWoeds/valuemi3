class AddProcessedToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :processed, :string
  end
end
