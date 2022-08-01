class CreateAnexo8s < ActiveRecord::Migration
  def change
    create_table :anexo8s do |t|
      t.string :code
      t.string :name
      t.string :code_nube

      t.timestamps null: false
    end
  end
end
