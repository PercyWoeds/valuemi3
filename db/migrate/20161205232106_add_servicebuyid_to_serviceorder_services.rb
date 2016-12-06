class AddServicebuyidToServiceorderServices < ActiveRecord::Migration
  def change
    add_column :serviceorder_services, :servicebuy_id, :integer
  end
end
