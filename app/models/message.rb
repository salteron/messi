class Message < ApplicationRecord
  has_many :deliveries, dependent: :destroy
end
