class User < ApplicationRecord
  has_many :messages
  has_secure_password
end
