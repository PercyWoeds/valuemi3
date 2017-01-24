class AddDsubdiarioToDsubdiarios < ActiveRecord::Migration
  def change
    add_column :dsubdiarios, :dsubdiario, :string
  end
end
