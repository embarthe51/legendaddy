class Booking < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  belongs_to :kid

  validates :kid, presence: true
  validates :start_at, presence: true

  def formated_booking_start
    "You choose to attend on #{start_at.strftime('%A at %H h %M on %d/%m/%Y')}"
  end
end
