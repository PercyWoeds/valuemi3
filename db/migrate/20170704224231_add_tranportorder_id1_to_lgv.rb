class AddTranportorderId1ToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :tranportorder_id, :integer
  end
end
