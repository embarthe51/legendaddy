class Activity < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :user
  validates :title, :description, :address, :workshop, presence: true
end
