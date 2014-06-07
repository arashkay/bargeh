object @post
extends '/posts/post'
child :comments do
  extends '/comments/comment'
  glue :user do 
    attributes :username, :avatar_name
  end
end
