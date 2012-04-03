class User < ActiveRecord::Base
  include Gravtastic
  gravtastic :size => 50
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation

  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\_@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validates_exclusion_of :username, :in => %w( admin superuser following), :message => "is not a useable username"

  has_many :flits, :dependent => :destroy
  has_many :friendships
  has_many :friends, :through => :friendships

  def friends_of
    Friendship.find(:all, :conditions => ["friend_id = ?", self.id]).map{|f|f.user}
  end
  # add_friend()
  def add_friend(friend)
    friendship = friendships.build(:friend_id => friend.id)
    if !friendship.save
      logger.debug "User '#{friend.email}' already exist in the user's friendship list."
    end
  end

  def remove_friend(friend)
    #debugger
    friendship = Friendship.find(:first, :conditions => ["user_id = ? and friend_id = ?", self.id, friend.id])
    #friendship = friendships.find(:friend_id => friend.id)
    if friendship
        friendship.destroy
    end
  end

  def is_friend?(friend)
    return self.friends.include? friend
  end

  def all_flits
    Flit.find(:all, :conditions => ["user_id in (?)", friends.map(&:id).push(self.id)], :order => "created_at desc")
  end

  def self.find_by_search_query(q)
    User.find(:all, :conditions => ["username like ? OR email like ?", "%#{q}%", "%#{q}%"])
  end


  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
