class PostsController < ApiController
  
  def index
    latitude  = params.fetch(:scope, {})[:latitude].blank?  ? nil : params[:scope][:latitude]
    longitude = params.fetch(:scope, {})[:longitude].blank? ? nil : params[:scope][:longitude]
    return render Error.missed_param(:scope) if latitude.blank? || longitude.blank?
    @posts = Post.includes(:user).around_me latitude, longitude
    render :posts
  end

  def show
    @post = Post.find params[:id]
    @post.comments.includes(:user).references(:user)
  end

  def create
    @post = @current_user.posts.find_or_create post_params
    if @post.errors.any?
      render Error.failed @post.errors
    else
      render :post
    end
  end

  def update
    @post = @current_user.posts.where( id: params[:id] ).find_if_close_enough( post_params[:latitude], post_params[:longitude] )
    return render Error.not_found if @post.blank?
    @post.update_attributes post_params
    render :post
  end

  def flagged
    Flag.report Post.find(params[:id]), params.fetch(:flag, {})[:body]
    render '/layouts/true'
  end

  def destroy
    @current_user.posts.where( id: params[:id] ).first.destroy
    render 'layouts/true'
  end

private

  def post_params
    params[:post].blank? ? {} : params.require(:post).permit( :body, :latitude, :longitude )
  end

end 
