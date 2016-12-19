class AddDescriptionToMoneda < ActiveRecord::Migration
  def change
    add_column :monedas, :description, :string
  end
end
