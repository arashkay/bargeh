class Panel::GeneralController < Panel::MainController

  skip_load_and_authorize_resource
  before_filter :is_wizard_or_redirect!, except: [:index]

  def index
  end

  def api
    @user = User.find(params[:id]) unless params[:id].blank?
    @routes = []
    Rails.application.routes.routes.each do |route|
      path = route.path.spec.to_s.gsub('(.:format)', '.json')
      method = route.constraints[:request_method].to_s.gsub(/[\D]*\^/, '').gsub(/\$[\D]*/,'')
      @routes << "#{method} #{path}" if path.starts_with?('/api')
    end
  end

  def charts
    @cities = Location.top_cities
    @registrations = User.select('date(created_at) as reg_date, count(date(created_at)) as cnt').group('date(created_at)').order('reg_date DESC').limit(20)
    @checkins = UserVenue.select('date(created_at) as reg_date, count(date(created_at)) as cnt').group('date(created_at)').order('reg_date DESC').limit(20)
    @total_users = User.count
    @total_venues = Venue.count
    @total_checkins = UserVenue.count
    @total_matches = Relation.where(state:'connected').count
  end

end
