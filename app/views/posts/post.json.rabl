object @post
attributes :id, :body, :latitude, :longitude, :comments_count
node(:has_existed){ |o| o.has_existed? }
child :user do
  attributes :id, :username, :avatar_name, :user_type
end
