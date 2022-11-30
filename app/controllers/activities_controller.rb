class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
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
  end

  def show
    @activity = Activity.find(params[:id])
  end
end
