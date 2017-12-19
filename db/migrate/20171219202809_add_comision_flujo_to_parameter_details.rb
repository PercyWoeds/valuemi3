class AddComisionFlujoToParameterDetails < ActiveRecord::Migration
  def change
    add_column :parameter_details, :comision_flujo, :float
    add_column :parameter_details, :comision_mixta, :float
    add_column :parameter_details, :comision_mixta_saldo, :float
  end
end
