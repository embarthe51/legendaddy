class Message < ApplicationRecord
  belongs_to :convo
  belongs_to :user

  validates_presence_of :content, :convo_id, :user_id
end
