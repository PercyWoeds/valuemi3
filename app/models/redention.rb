class Redention < ActiveRecord::Base
    
    has_many :redention_details, inverse_of: :redention, dependent: :destroy
	has_many :items, through: :redention_details
	belongs_to :user

	validates :number, presence: true
	validates :date, presence: true

	accepts_nested_attributes_for :redention_details, reject_if: :redention_detail_rejectable?,
									allow_destroy: true

	enum state: [:draft, :confirmed]

	def total
		details = self.redention_details

		total = 0.0
		details.flat_map do |d|
			total += d.quantity * d.price
		end
		total
	end

	private

		def sale_detail_rejectable?(att)
			att[:item_id].blank? || att[:quantity].blank? || att[:price].blank? || att[:quantity].to_f <= 0 || att[:price].to_f <= 0
		end
		
end
