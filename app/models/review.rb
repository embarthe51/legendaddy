class Review < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  def self.avg_rating(rating)
    return_str = ""
    while rating != 0 && rating.positive?
      return_str << "<i class='fa-regular fa-star review-star'></i>" if rating > 1
      return_str << "<i class='fa-regular fa-star-half review-star'></i>" if rating < 1
      rating -= 1
    end
    return_str
  end

  validates :content, presence: true
end
