class MessagesController < ApiController
  
  def conversations
    return render Error.missed_param('scope') if params[:scope].nil?
    @conversations = Conversation.for @current_user.id, params[:scope][:page]
  end

  def conversation_viewed
    Conversation.viewed_by params[:id], @current_user.id
    render '/layouts/true'
  end

  def messages
    if params[:scope].blank?
      @messages = Message.between @current_user.id, params[:with_user_id]
    else
      @messages = Message.between @current_user.id, params[:with_user_id], params[:scope][:message_id], params[:scope][:is_read]
    end
  end
 
  def show
    @current_user.messages.with 
  end

  def create
    @message = @current_user.messages.wanna_send message_params
    if @message.errors.any?
      render Error.failed @message.errors
    else
      render :message
    end
  end

  def viewed
    Message.mark_as_read_for @current_user.id, params[:ids]
    render '/layouts/true'
  end

private

  def message_params
    params.require(:message).permit :to_user_id, :body
  end

end
