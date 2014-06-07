object @current_user
attributes :first_name, :last_name, :number, :email, :username, :premium, :avatar_name
unless params[:extend].nil?
  if params[:extend].include? 'device'
    child :devices do
      attributes :id, :device_type, :device_id, :can_notify
    end
  end
  if params[:extend].include? 'prefix'
    attributes :username_prefix
  end
  if params[:extend].include? 'posts'
    child :posts do
      attributes :id, :body, :comments_count
    end
  end
end

