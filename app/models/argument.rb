class Argument < ActiveRecord::Base
  belongs_to :topic
  extend FriendlyId
  friendly_id :statement, use: :slugged

	has_many :signatures
	has_many :pro_signatures, class_name: 'Signature'
	has_many :pros, -> { uniq }, through: :pro_signatures, class_name: 'BitcoinAddress', source: :bitcoin_address

	def pro_statement
		"I support #{statement}"
	end



	def update_validity
		self.pros_sum = pros.uniq.sum(&:balance)
		self.validity = pros_sum
		self.all_sum = pros_sum 
		self.min_sum = pros_sum
		save!
	end

end