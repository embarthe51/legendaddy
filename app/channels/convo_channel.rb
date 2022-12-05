class ConvoChannel < ApplicationCable::Channel
  def subscribed
    convo = Convo.find(params[:id])
    stream_for convo
  end

  def unsubscribed
  end
end
