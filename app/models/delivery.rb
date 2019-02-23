class Delivery < ApplicationRecord
  belongs_to :message
  enum recipient_messenger: %i[telegram]
end
