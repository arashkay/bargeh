class Post < ActiveRecord::Base

  belongs_to :user
  has_many :comments, dependent: :destroy
  reverse_geocoded_by :latitude, :longitude

  def has_existed?
    @has_existed || false
  end

  def has_existed=(exists)
    @has_existed = exists
  end

  def self.around_me( latitude, longitude, limit=APP::SEARCH::LIMIT, distance=APP::SEARCH::DISTANCE )
    near([latitude, longitude], distance, :units => :km)
  end

  def self.find_or_create(params)
    post = new params
    current = find_if_close_enough post.latitude, post.longitude
    if current.blank?
      post.save 
      return post
    end
    current.has_existed = true
    current.body = post.body
    current
  end

  def self.find_if_close_enough( latitude, longitude )
    around_me( latitude, longitude, 1, 0.2 ).first
  end

end
