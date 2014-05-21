# @author Arash Kay <arash@tectual.com.au>
class Message < ActiveRecord::Base

  include Elasticsearch::Model

#ATTRIBUTES
  belongs_to :user
  belongs_to :to, class_name: 'User', foreign_key: :to_user_id
  validates :user_id, :to_user_id, presence: true
  
  def name
    @name = (user_id>to_user_id ? "#{to_user_id}-#{user_id}" : "#{user_id}-#{to_user_id}") if @name.nil?
    @name
  end

  after_create :conversation_cache, :will_notify
  
  def conversation_cache
    conversation = Conversation.find_or_initialize_by self.user_id, self.to_user_id
    conversation.assign_attributes( { user_id: self.user_id, to_user_id: self.to_user_id, last_message_id: self.id } )
    conversation.save
  end

  def self.safe_import
    find_in_batches(batch_size:1) do |batch|
      batch.each do |record| 
        record.conversation_last_message_index
        sleep 1
      end
    end
  end

  def self.between( user_id, to_user_id, after=nil, is_read=nil )
    messages = where( [ "(user_id=? AND to_user_id=?) OR (to_user_id=? AND user_id=?)", user_id, to_user_id, user_id, to_user_id ] ).order('id DESC')
    unless after.blank? || after==0
      messages = messages.where( ['id > ?', after] )
    end
    unless is_read.blank?
      messages = messages.where( ['is_read = ?', is_read] )
    end
    messages.includes([:user, :to])
  end

  def self.wanna_send(params)
    create params
  end

  def self.mark_as_read_for( user_id, ids)
    Message.where(to_user_id: user_id, id: ids).update_all 'is_viewed = true'
  end

  # Queue a notification for newly created messages.
  def will_notify
    #Resque.safe_enqueue Notification, to_user_id, id, APP::NOTIFICATIONS::MESSAGE
  end

  def notify(device)
    message = "#{user.first_name}: #{body.truncate(12)}"
    case device.device_type
      when APP::DEVICE::IOS
        APNS.send_notification device.notification_id, { alert: message, other: { screen: 'messages', with_user_id: user_id }, :badge => Conversation.unviewed_count(to_user_id), :sound => 'default' }
      when APP::DEVICE::ANDROID
        GCM.send_notification device.notification_id, { message: message }
    end
  end
  
end
