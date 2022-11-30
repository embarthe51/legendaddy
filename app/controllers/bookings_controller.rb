class BookingsController < ApplicationController
  before_action :find_booking, only: %i[show]
  before_action :find_activity, only: %i[new create]

  def index
    @bookings = Booking.all
  end

  def show
  end

  def new
    @kids_and_ids = current_user.kids.map { |item| [item.first_name.capitalize, item.id] }
    @booking = Booking.new
  end

  def create
    @booking = Booking.new
    @booking.kid = Kid.find(booking_params["kid"].to_i)
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
    params.require(:booking).permit(:kid)
  end

  def find_activity
    @activity = Activity.find(params[:activity_id])
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end
end
