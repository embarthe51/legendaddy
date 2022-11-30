class Activity < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, :description, :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def formated_open_times
    if workshop
      "<i class='fa-solid fa-calendar-days'></i> <br/> #{start_at.strftime('%d/%m/%Y')} <br/>
      at : #{start_at.strftime('%H h %M')}"
    else
      "
        <i class='fa-solid fa-calendar-days'></i> <br/>
        From : #{open_hour.hour} h #{0 if open_hour.min < 10}#{open_hour.min} <br/>
        to : #{open_hour.hour} h #{0 if open_hour.min < 10}#{open_hour.min} <br/>
        Days : #{format_open_days(open_days)}
      "
    end
  end

  def format_open_days(open_days_unformated)
    arr_of_days = open_days_unformated
    arr_of_days.map! { |item| Date::DAYNAMES[item.to_i] }.join(', ')
  end
end
