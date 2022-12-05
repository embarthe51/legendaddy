class ReviewsController < ApplicationController
  before_action :set_activity, only: %i[new create]

  def create
    @review = Review.new(review_params)
    @review.activity = @activity
    if @review.save
      redirect_to activity_path(@activity)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @activity = Activity.find(params[:activity_id])
    @reviews = Review.includes(:user).where(activity: params[:activity_id])
  end

  def new
    @activity = Activity.find(params[:activity_id])
    @review = Review.new
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end
