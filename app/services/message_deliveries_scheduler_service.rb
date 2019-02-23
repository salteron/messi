# frozen_string_literal: true

class MessageDeliveriesSchedulerService
  def initialize(message)
    @message = message
  end

  def schedule_deliveries
    @message.deliveries.map do |delivery|
      DeliveryJob.perform_at(@message.send_at, delivery.id)
    end
  end
end
