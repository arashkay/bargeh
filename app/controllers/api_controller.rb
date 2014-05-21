class ApiController < ApplicationController
  
  before_filter :authorize 
  layout 'v1'

protected
  def authorize
    token = request.headers['AUTH-TOKEN']
    if token.blank?
      render Error.unauthorized "You are not authorized! Token not set!"
      return false
    end
    @current_user = User.find_by_authentication_token token unless token.blank?
    if @current_user.blank?
      render Error.unauthorized
      return false
    end
  end

  def current_user
    @current_user
  end

end
