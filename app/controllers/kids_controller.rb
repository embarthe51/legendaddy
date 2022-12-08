class KidsController < ApplicationController
  # def new
  #   @kid = Kid.new
  # end

  def create
    @kid = Kid.new(kid_params)
    @kid.user = current_user
    redirect_to edit_user_registration_path if @kid.save
  end

  def destroy
    @kid = Kid.find(params[:id])
    Booking.where(kid: @kid).destroy_all
    @kid.destroy
    redirect_to edit_user_registration_path
  end

  private

  def kid_params
    params.require(:kid).permit(:first_name)
  end
end
