class AddCdevueltoToLgvs < ActiveRecord::Migration
  def change
    add_column :lgvs, :cdevuelto,  :string
    add_column :lgvs, :cdescuento, :string
    add_column :lgvs, :creembolso, :string
  end
end
