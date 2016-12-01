class AddRucToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :ruc, :string, :limit=> 11
  end 
    
end
