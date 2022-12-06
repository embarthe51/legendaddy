class BookingsController < ApplicationController
  before_action :find_booking, only: %i[show]
  before_action :find_activity, only: %i[new create]
  # before_action :find_availability, only: %i[new create]

  def index
    @bookings = Booking.includes(:kid, :activity).where(user: current_user)
  end

  def show
    # @other_legendads_attending = User.includes(:bookings).where(activity: activity)
    @other_legendads_attending = User.all.select { |item| item.bookings.include?(@booking) }
  end

  def new
    @kids_and_ids = current_user.kids.map { |item| [item.first_name.capitalize, item.id] }
    @user_availabilities = current_user.availabilities.map { |item| [item.start_at.strftime('%H h %M on %d/%m/%Y'), item.start_at]}
    @booking = Booking.new
  end

  def create
    @booking = Booking.new
    @booking.kid = Kid.find(booking_params["kid"].to_i)
    @booking.user = current_user
    @booking.activity = @activity
    @availability = Availability.find(params[:availability_id])
    @booking.start_at = @availability.start_at
    @booking.end_at = @availability.end_at
    tab_id = %w[today-tab tomorrow-tab day-three-tab][@availability.start_at.to_date.ajd.to_i - Date.today.ajd.to_i]
    if @booking.save
      redirect_to availabilities_path(tab_id: tab_id)
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    tab_id = %w[today-tab tomorrow-tab day-three-tab][@booking.start_at.to_date.ajd.to_i - Date.today.ajd.to_i]
    redirect_to availabilities_path(tab_id: tab_id)
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

  # def find_availability
  #   @availability = Availability.find(params[:availability_id])
  # end
end
