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
    @message.save
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def find_convo
    @convo = Convo.find(params[:convo_id])
  end
end
