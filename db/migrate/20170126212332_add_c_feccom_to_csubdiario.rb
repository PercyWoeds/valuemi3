class AddCFeccomToCsubdiario < ActiveRecord::Migration
  def change
    add_column :csubdiarios, :cfeccom, :string
  end
end
