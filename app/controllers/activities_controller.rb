class ActivitiesController < ApplicationController
  def index
    filter
  end

  def search
    filter
    respond_to do |format|
      format.json do
        render json: {
          html: render_to_string(
            partial: "activities/list",
            locals: { filtered_activities: @filtered_activities },
            formats: [:html]
          ),
          map_html: render_to_string(
            partial: "activities/map",
            locals: { markers: @markers },
            formats: [:html]
          )
        }
      end
      format.html
    end
  end

  def show
    # raise
    @activity = Activity.find(params[:id])
    @markers = [{
      lat: @activity.latitude,
      lng: @activity.longitude,
      info_window: render_to_string(partial: "activities/info_window", locals: { activity: @activity },
      formats: [:html])
    }]
    @kids_and_ids = current_user.kids.map { |item| [item.first_name.capitalize, item.id] }
    @user_availability = Availability.find(params[:availability_id])
    # @user_availabilities = current_user.availabilities.map { |item| [item.start_at.strftime('%H h %M on %d/%m/%Y'), item.start_at]}
    @booking = Booking.new
  end

  def filter
    if params[:availability_id].present?
      @availability = Availability.find(params[:availability_id])
      if params.dig(:query, :tag_list)&.any? { |string| !string.empty? }
        @activities = Activity.tagged_with(params.dig(:query, :tag_list), any: true).on_availability(@availability)
      else
        @activities = Activity.on_availability(@availability)
      end
    else
      if params.dig(:query, :tag_list)&.any? { |string| !string.empty? }
        @activities = Activity.tagged_with(params.dig(:query, :tag_list), any: true)
      else
        @activities = Activity.all
      end
    end

    @filtered_activities = []
    current_user.availabilities.each do |a|
      @filtered_activities << Activity.on_availability(a)
    end
    @filtered_activities = @filtered_activities.flatten.uniq && @activities
    @markers = @filtered_activities.map do |a|
      {
        lat: a.latitude,
        lng: a.longitude,
        info_window: render_to_string(partial: "activities/info_window", locals: { activity: a },
          formats: [:html])
      }
    end
  end
end
