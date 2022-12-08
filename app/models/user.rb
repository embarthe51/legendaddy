class User < ApplicationRecord
  has_many :activities
  has_many :bookings
  has_many :kids
  has_many :availabilities
  has_many :reviews
  has_one_attached :photo
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
