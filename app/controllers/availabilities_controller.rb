class AvailabilitiesController < ApplicationController

  def index
    @tomorrow = Date.tomorrow
    @bookings = Booking.all
    @availabilities = Availability.select do |availability|
      matching_bookings = @bookings.map do |booking|
        booking if booking.start_at == availability.start_at
      end.compact
      matching_bookings.empty?
    end
    @grouped_availabilities = @availabilities.group_by { |a| a.start_at.strftime('%a %d %b %Y') }

    # @booking = Booking.find(params[:id])
    # @availability = Availability.find(params[:availability_id])
    # @booking.start_at = @availability.start_at
    # @booking.end_at = @availability.end_at
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

    redirect_to availabilities_path(:tab_id)
  end

  private

  def availability_params
    params.require(:availability).permit(:start_at, :end_at, :user_id)
  end
end
