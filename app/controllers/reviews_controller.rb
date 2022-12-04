class ReviewsController < ApplicationController
  def index
    @activity = Activity.find(params[:activity_id])
    @reviews = Review.includes(:user).where(activity: params[:activity_id])
  end
end
