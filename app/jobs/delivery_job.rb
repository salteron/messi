# frozen_string_literal: true

class DeliveryJob
  include Sidekiq::Worker

  sidekiq_options(retry: 10)

  def perform(delivery_id)
    delivery = Delivery.find(delivery_id)
    DeliveryService.new(delivery).perform
  end
end
