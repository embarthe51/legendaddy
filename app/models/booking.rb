class Booking < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  belongs_to :kid

  def formated_booking_start
    "You choose to attend at #{start_at.strftime('%H h %M on %d/%m/%Y')}"
  end
end
