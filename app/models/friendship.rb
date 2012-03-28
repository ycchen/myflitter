class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, :class_name => 'User'
	validates :user_id, :friend_id, presence: true
	#validates :friend_id, :scope => :user_id,uniqueness: true
	validates_uniqueness_of :friend_id, :scope => :user_id
  
end
