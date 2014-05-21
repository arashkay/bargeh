collection @conversations

attributes :id, :created_at 
node :is_viewed do |conversation|
  (@current_user.id == conversation.user_id ? conversation.user_viewed : conversation.to_user_viewed)
end
node :to do |conversation|
  partial 'users/user', object: (@current_user.id == conversation.user_id ? conversation.to : conversation.user)
end
node :last_message do |conversation|
  partial '/messages/message', object: conversation.last_message
end
