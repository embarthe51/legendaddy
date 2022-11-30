class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
    @filtered_activities = []
    @activities.each do |activity|
      if activity.workshop?
        current_user.availabilities.each do |availability|
          @filtered_activities << activity if availability.start_at <= activity.start_at && availability.end_at >= activity.end_at
        end
      end
    end
    @filtered_activities = @filtered_activities.uniq
  end

  def show
    @activity = Activity.find(params[:id])
    @markers = [{
      lat: @activity.latitude,
      lng: @activity.longitude
    }]
  end
end
