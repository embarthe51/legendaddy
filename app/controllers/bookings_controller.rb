class BookingsController < ApplicationController
  before_action :find_booking, only: %i[show]
  before_action :find_activity, only: %i[new create]
  before_action :find_availability, only: %i[new create]

  def index
    @bookings = Booking.includes(:kid, :activity).all
  end

  def show
  end

  def new
    @kids_and_ids = current_user.kids.map { |item| [item.first_name.capitalize, item.id] }
    @user_availabilities = current_user.availabilities.map { |item| [item.start_at.strftime('%H h %M on %d/%m/%Y'), item.start_at]}
    @booking = Booking.new

  end

  def create
    @booking = Booking.new
    @booking.kid = Kid.find(booking_params["kid"].to_i)
    @booking.start_at = booking_params["start_at"]
    @booking.user = current_user
    @booking.activity = @activity
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:kid, :start_at)
  end

  def find_activity
    @activity = Activity.find(params[:activity_id])
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end

  def find_availability
    @availability = Availability.find(params[:availability_id])
  end
end
