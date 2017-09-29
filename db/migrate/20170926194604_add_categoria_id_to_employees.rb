class AddCategoriaIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :categoria_id, :integer
    add_column :employees, :file_nro, :string
    add_column :employees, :fecha_nacimiento, :datetime 
    add_column :employees, :ocupacion_id, :integer
    add_column :employees, :carnet_seguro, :string
    add_column :employees, :sexo_id, :integer
    add_column :employees, :tipotrabajador_id, :integer
    add_column :employees, :estado_civil_id, :integer
    add_column :employees, :quincena, :float
    add_column :employees, :grado_instruccion_id, :integer
    add_column :employees, :sueldo, :float
    add_column :employees, :sueldo_moneda, :integer
    add_column :employees, :horas_diarias, :float
    add_column :employees, :calculo_base_hora, :string
    add_column :employees, :nacionalidad_id, :integer
    add_column :employees, :calculo_tardanza_hora, :string
    add_column :employees, :fecha_ingreso, :datetime 
    add_column :employees, :fecha_cese, :datetime 
    add_column :employees, :confianza_id, :integer
    add_column :employees, :anexo_referencia, :string
    add_column :employees, :motivo_cese_id, :integer
    add_column :employees, :anexo_contable, :string
    
    
  end
end
