class Convo < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'

  has_many :messages, dependent: :destroy
  validates_uniqueness_of :sender_id, scope: :receiver_id
  scope :between, -> (sender_id, receiver_id) do
    where("(convos.sender_id =? AND convos.receiver_id =?)
      OR (convos.receiver_id = ? AND convos.sender_id =?)",
      sender_id, receiver_id, receiver_id, sender_id)
  end
end
