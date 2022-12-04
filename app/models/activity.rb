class Activity < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, :description, :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  acts_as_taggable_on :tags

  scope :on_availability, -> (availability) {
    where(workshop: true)
    .where("start_at >= :availability_start AND end_at <= :availability_end", availability_start: availability.start_at, availability_end: availability.end_at)
    .or(
      where(workshop: false)
      .where("open_days @> ARRAY[:availability_day]", availability_day: availability.start_at.wday)
      .and(
        where("CAST(extract(hour from open_hour) as INTEGER) >= :availability_start_at AND CAST(extract(hour from open_hour) as INTEGER) < :availability_end_at", availability_start_at: availability.start_at.hour, availability_end_at: availability.end_at.hour)
        .or(
          where("CAST(extract(hour from closing_hour) as INTEGER) > :availability_start_at AND CAST(extract(hour from closing_hour) as INTEGER) <= :availability_end_at", availability_start_at: availability.start_at.hour, availability_end_at: availability.end_at.hour)
        )
      )
    )
  }

  def formated_open_times
    if workshop
      "<i class='fa-solid fa-calendar-days'></i> <br/> Le #{start_at.strftime('%d/%m/%Y')} <br/>
      à : #{start_at.strftime('%H h %M')}"
    else
      "
        <i class='fa-solid fa-calendar-days'></i> <br/>
        De : #{open_hour.hour} h #{0 if open_hour.min < 10}#{open_hour.min} <br/>
        à : #{closing_hour.hour} h #{0 if closing_hour.min < 10}#{closing_hour.min} <br/>
        Jours : #{format_open_days}
      "
    end
  end

  def format_avg_rating
    avg = reviews.map(&:rating).sum.fdiv(reviews.length).round(2)
    Review.avg_rating(avg)
  end

  def format_reviews
    if reviews.any?
      "rating: #{format_avg_rating} #{reviews.count} vote#{'s' if reviews.count > 1}"
    else
      "reviews: cette activité n'a pas de review"
    end
  end

  def format_open_days
    open_days.map { |item| Date::DAYNAMES[item.to_i] }.join(', ')
  end

  def self.filtered_activities(user)

  end

end
