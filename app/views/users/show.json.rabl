object @user
extends '/users/user'
child :posts do
  attributes :id, :body, :comments_count
end
