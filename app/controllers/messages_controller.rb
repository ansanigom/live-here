class MessagesController < ApplicationController

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.avatar_id = current_user.photo.key
    @performance =  Performance.find(params[:performance_id])
    @message.performance = @performance
    authorize @message
    if @message.save
      PerformanceChannel.broadcast_to(
        @performance,
        render_to_string(partial: "message", locals: { message: @message })
      )
      redirect_to performance_path(@performance, anchor: "message-#{@message.id}")
    else
      render 'performances/show'
    end
  end

  private


  def message_params
    params.require(:message).permit(:content, :avatar_id)
  end
end
