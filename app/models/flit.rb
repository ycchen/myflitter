class Flit < ActiveRecord::Base
	belongs_to :user
	validates :user_id, :message, :created_at, presence: true
end
