class Flit < ActiveRecord::Base
	belongs_to :user
	#validates :user_id, :message, :created_at, presence: true
	validates_presence_of :user_id, :message, :created_at
end
