class User < ActiveRecord::Base

  attr_accessor :username_prefix, :username_postfix
  has_many :messages
  has_many :comments
  has_many :posts

  validates :number, uniqueness: true, allow_nil: true
  validates :username, uniqueness: true, length: { maximum: 12 }, format: { with: /\A[\w]*\z/, message: 'should be only letters and numbers' }, allow_nil: true, allow_blank: false
  
  has_many :devices

  def initial
    "#{first_name} #{last_name.first}."
  end

  def username_prefix
    "ALPHA_"
  end

  def username_postfix=(postfix)
    self.username = "#{self.username_prefix}#{postfix}".upcase
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

end
