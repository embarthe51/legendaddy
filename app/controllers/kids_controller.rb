class KidsController < ApplicationController
  # def new
  #   @kid = Kid.new
  # end

  def create
    @kid = Kid.new(kid_params)
    @kid.user = current_user
    redirect_to edit_user_registration_path if @kid.save
  end

  private

  def kid_params
    params.require(:kid).permit(:first_name)
  end
end
