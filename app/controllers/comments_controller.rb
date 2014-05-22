class CommentsController < ApiController
  
  def create
    @comment = @current_user.comments.create post_id: comment_params[:post_id], body: comment_params[:body]
    render :comment
  end

  def destroy
    @current_user.comments.where(id: params[:id]).first.destroy
    render '/layouts/true'
  end

private

  def comment_params
    params[:comment].blank? ? {} : params.require(:comment).permit( :body, :post_id )
  end

end
