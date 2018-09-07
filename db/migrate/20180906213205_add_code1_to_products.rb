class AddCode1ToProducts < ActiveRecord::Migration
  def change
    add_column :products, :code1, :string
    add_column :products, :code2, :string
  end
end
