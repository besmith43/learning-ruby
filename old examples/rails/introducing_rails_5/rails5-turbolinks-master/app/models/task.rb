class Task < ApplicationRecord
  scope :complete, -> { where(status: true) }
  scope :incomplete, -> { where(status: false) }
end
