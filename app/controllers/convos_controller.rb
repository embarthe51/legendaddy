class ConvosController < ApplicationController
  def index
    @convos = Convo.where(sender_id: current_user).or(Convo.where(receiver_id: current_user))
  end

  def create
    # @convo = Convo.new(sender: current_user, receiver: convo_params)
  end

  private

  def convo_params
    # params.require(:convo).permit(:receiver_id)
  end
end
