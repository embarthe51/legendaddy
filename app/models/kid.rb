class Kid < ApplicationRecord
  has_many :bookings
  belongs_to :user
end
