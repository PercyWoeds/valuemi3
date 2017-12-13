class BankAcount < ActiveRecord::Base

	belongs_to :bank
	belongs_to :moneda 

	has_many :supplier_payments
	has_many :customer_payments
	has_many :bankdetails

	def get_banco(id)

		@a = Bank.find(id)
		return @a.name 
	end

	def get_monedas
		monedas = Moneda.all 
    	return monedas		
	end

	def get_bancos
		bancos = Bank.all 
    	return  bancos		
	end
end
