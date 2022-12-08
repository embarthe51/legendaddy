class KidsController < ApplicationController
  # def new
  #   @kid = Kid.new
  # end

  def create
    @kid = Kid.new(kid_params)
    @kid.user = current_user
    if @kid.save
      raise
      redirect_to edit_user_registration_path
    end
  end

  private

  def kid_params
    params.require(:kid).permit(:first_name)
  end
end
