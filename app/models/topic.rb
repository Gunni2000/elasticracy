class Topic < ActiveRecord::Base
	extend FriendlyId
  friendly_id :topic, use: :slugged

	has_many :arguments, dependent: :destroy
end
