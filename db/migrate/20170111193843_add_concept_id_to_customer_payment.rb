class AddConceptIdToCustomerPayment < ActiveRecord::Migration
  def change
    add_column :customer_payments, :concept_id, :integer
  end
end
