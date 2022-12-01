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
    @activity = Activity.find(params[:id])
    @markers = [{
      lat: @activity.latitude,
      lng: @activity.longitude,
      info_window: render_to_string(partial: "activities/info_window", locals: { activity: @activity },
      formats: [:html])
    }]
    @booking = Booking.new
  end

  def filter
    if params.dig(:query, :tag_list)&.any? { |string| !string.empty? }
      @activities = Activity.tagged_with(params.dig(:query, :tag_list), any: true)
    else
      @activities = Activity.all
    end

    @filtered_activities = []
    @activities.each do |activity|
      if activity.workshop?
        current_user.availabilities.each do |availability|
          @filtered_activities << activity if availability.start_at <= activity.start_at && availability.end_at >= activity.end_at
        end
      else
        activity.open_days.each do |day|
          current_user.availabilities.each do |availability|
            activity_open_covered = availability.start_at.hour <= activity.open_hour.hour && activity.open_hour.hour < availability.end_at.hour
            activity_closing_covered = availability.start_at.hour < activity.closing_hour.hour && activity.closing_hour.hour <= availability.end_at.hour
            if (day == availability.start_at.wday) && (activity_open_covered || activity_closing_covered)
              @filtered_activities << activity
            end
          end
        end
      end
    end
    @filtered_activities = @filtered_activities.uniq
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
