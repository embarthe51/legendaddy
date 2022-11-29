class Activity < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, :description, :address, :workshop, presence: true
end
