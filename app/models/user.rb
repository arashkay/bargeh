class User < ActiveRecord::Base

  attr_accessor :username_prefix, :username_postfix
  has_many :messages
  has_many :comments
  has_many :posts

  validates :number, uniqueness: true, allow_nil: true
  validates :username, uniqueness: true, length: { maximum: 10 }, format: { with: /\A\p{Word}*\z/, message: 'should be only letters and numbers' }, allow_nil: true, allow_blank: false
  
  has_many :devices

  before_create :set_defaults

  def initial
    "#{first_name} #{last_name.first}."
  end

  def username_prefix
    APP::USERNAME::PREIX
  end

  def username_postfix=(postfix)
    postfix = postfix.gsub(/\p{Common}/, '').gsub(/[\w]/, '').persian_cleanup
    self.username = "#{self.username_prefix}#{postfix}"
  end
   
  def self.me_by_number( number )
    self.where( number: number ).first
  end
   
  def self.me_by_device( device_id )
    Device.where( device_id: device_id ).first.try :user
  end

  def new_session!
    self.authentication_token = loop do
      token = SecureRandom.urlsafe_base64 60
      break token unless User.exists?(authentication_token: token)
    end
    save
  end

private

  def set_defaults
    self.avatar_name = "avatar#{1+rand(10)}" if self.avatar_name.blank?
    if self.username.blank?
      loop do 
        self.username_postfix = APP::USERNAME::GENERATOR.sample(5).join.persian_cleanup
        break true unless User.exists?(username: self.username)
      end
    end
  end

end
