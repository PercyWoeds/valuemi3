class AddCodEmpToTirads < ActiveRecord::Migration
  def change
    add_column :tirads, :cod_emp, :string
  end
end
