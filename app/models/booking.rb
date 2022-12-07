class Booking < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  belongs_to :kid

  validates :kid, presence: true
  validates :start_at, presence: true

  def formated_booking_start
    "Vous avez choisi cette activité #{start_at.strftime('%A à %H h %M le %d/%m/%Y')}"
  end
end
