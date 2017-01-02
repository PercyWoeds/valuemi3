class CreateDeliverymines < ActiveRecord::Migration
  def change
    create_table :deliverymines do |t|

    
	
        t.timestamps null: false
        
    	t.belongs_to :delivery
		t.belongs_to :mine, class: 'Delivery'

	  
    end
  end
end
