class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
	t.string   "name"
    t.string   "internal_type"
    t.integer  "vendor_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "hidden",        :default => 0
    t.integer  "hidden_by"
    t.boolean  "cash"
    t.boolean  "change"
    t.boolean  "unpaid"
    t.boolean  "quote"
    t.integer  "position"
    t.integer  "company_id"
    t.datetime "hidden_at"

    end
  end
end
