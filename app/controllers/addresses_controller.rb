class AddressesController < ApplicationController

before_action :find_address 

def new
		
	@address = Address.new 	

end

def create

	@address =Address.new(address_params)
	@address.customer_id =@customer.id
	@address.user_id= current_user.id

	if @address.save
		redirect_to customer_path(@customer)	
	else
		render 'new'	

	end 
end

private

def address_params 
	params.require(:address).permit(:address,:address2,:city,:state)
end 	

def find_address
	@customer = Customer.find(params[:customer_id])
end 	

end



