class CreateDeclarationDeliveries < ActiveRecord::Migration
  def change
    create_table :declaration_deliveries do |t|

    	t.belongs_to :delivery
    	t.belongs_to :declaration 

      t.timestamps null: false
    end
  end
end
