class AddInicialToLgv < ActiveRecord::Migration
  def change
    add_column :lgvs, :inicial, :float
  end
end
