class Panel::MainController < ApplicationController
  
  alias_method :current_user, :current_admin

  before_filter :authenticate_admin!
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

protected
  def is_wizard_or_redirect!
    redirect_to root_path unless current_admin.is_wizard?
  end

end
