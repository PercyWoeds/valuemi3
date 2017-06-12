class AddCodeToCompros < ActiveRecord::Migration
  def change
    add_column :compros, :code, :string
  end
end
