class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_commit { MessageRelayJob.perform_later(self) }
end
