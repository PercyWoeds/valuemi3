class AddGrupoToGasto < ActiveRecord::Migration
  def change
    add_column :gastos, :grupo, :string
  end
end
