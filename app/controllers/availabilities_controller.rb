class AvailabilitiesController < ApplicationController

  def index
    @tomorrow = Date.tomorrow
    @availabilities = Availability.all
    @grouped_availabilities = @availabilities.group_by { |a| a.start_at.strftime('%a %d %b %Y') }
  end

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    @availability.user = current_user
    @availability.start_at = "#{params[:availability][:date]} #{params[:availability][:start_at]}"
    @availability.end_at = "#{params[:availability][:date]} #{params[:availability][:end_at]}"
    @availability.save

    redirect_to availabilities_path(tab_id: params.dig(:availability, :tab_id))
  end

  private

  def availability_params
    params.require(:availability).permit(:start_at, :end_at, :user_id)
  end
end
