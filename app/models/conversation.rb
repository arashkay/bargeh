class Conversation < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "#{APP::CONFIGS['prefix']}_#{self.table_name}"

  belongs_to :user
  belongs_to :to, class_name: 'User', foreign_key: :to_user_id
  belongs_to :last_message, class_name: 'Message', foreign_key: :last_message_id

  def self.for(user_id, page=0)
    page=0 if page.blank?
    ids = Conversation.search( query: { match_all: {} }, filter: { or:[{ term: { user_id: user_id }}, { term: { to_user_id: user_id }}] }, sort: [{date:'desc'}], size: APP::LISTING::LIMIT, from: APP::LISTING::LIMIT*page.to_i ).results.map{ |conversation| conversation._id }
    Conversation.where(  id: ids ).includes([:user, :to, :last_message]).order('updated_at DESC')
  end
  
  def self.find_between( from_id, to_id )
    Conversation.where(["(user_id=? AND to_user_id=?)OR(to_user_id=? AND user_id=?)", from_id, to_id, from_id, to_id]).first
  end
  
  # Total number of unread conversations for a specifc user
  #
  # @param user_id [Symbol]
  # @return [Integer]
  def self.unviewed_count(user_id)
    Message.where( is_viewed: false, to_user_id: user_id ).distinct.count(:user_id)
  end

  def self.find_or_initialize_by( from_id, to_id )
    conversation = Conversation.find_between from_id, to_id
    conversation = Conversation.new( { user_id: from_id, to_user_id: to_id} ) if conversation.blank?
    conversation
  end

  def self.find_or_create_by( from_id, to_id )
    conversation = Conversation.find_or_initialize_by from_id, to_id
    conversation.save
  end

  def self.viewed_by( id, user_id )
    conversation = Conversation.find id
    if user_id == conversation.user_id
      conversation.user_viewed = true
    elsif user_id == conversation.to_user_id
      conversation.to_user_viewed = true
    end
    conversation.save
  end

  def unview_for( current_user_id )
    if current_user_id == user_id
      to_user_viewed = false
    else
      user_viewed = false
    end
  end

  def as_indexed_json(options={})
    { last_message_id: last_message_id, user_id: user_id, to_user_id: to_user_id, date: updated_at.to_i }
  end

end
