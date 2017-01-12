class AddConceptIdToPaymentDetails < ActiveRecord::Migration
  def change
    add_column :payment_details, :concept_id, :string
    add_column :payment_details, :, :string
    add_column :payment_details, :integer, :string
  end
end
