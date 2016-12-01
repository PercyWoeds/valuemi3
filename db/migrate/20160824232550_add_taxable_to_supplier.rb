class AddTaxableToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :taxable, :string
  end
end
