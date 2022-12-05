class MessagesController < ApplicationController
  before_action :find_convo, only: [:index, :create]

  def index
    @messages = @convo.messages
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.convo_id = params[:convo_id]
    if @message.save
      ConvoChannel.broadcast_to(
        @convo,
        render_to_string(partial: "message", locals: { message: @message})
      )
      head :ok
      # redirect_to convo_messages_path(@convo)
    else
      @messages = @convo.messages
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def find_convo
    @convo = Convo.find(params[:convo_id])
  end
end
