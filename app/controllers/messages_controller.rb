class MessagesController < ApplicationController
  before_action :find_convo, only: [:index, :create]

  def index
    unless @convo.sender == current_user || @convo.receiver == current_user
      redirect_to convos_path, notice: "Vous n'avez pas d'authorisation"
    end
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
