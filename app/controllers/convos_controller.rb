class ConvosController < ApplicationController
  def index
    @convos = Convo.where(sender_id: current_user)
  end
end
