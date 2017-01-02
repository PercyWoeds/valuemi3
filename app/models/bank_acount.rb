class BankAcount < ActiveRecord::Base

	belongs_to :bank

	has_many :supplier_payments

	def get_banco(id)

		@a = Bank.find(id)


		return @a.name 



	end

 


end
