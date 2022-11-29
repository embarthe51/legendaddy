class AvailabilitiesController < ApplicationController

  def index
    @availabilities = Availability.all
  end

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    @availability.user = current_user
    @availability.save
    redirect_to availabilities_path
  end

  private

  def availability_params
    params.require(:availability).permit(:start_at, :end_at, :user_id)
  end
end
