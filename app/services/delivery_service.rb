# frozen_string_literal: true

class DeliveryService
  def initialize(delivery)
    @delivery = delivery
  end

  def perform
    messenger_gateway.deliver(
      @delivery.message.text,
      to: @delivery.recipient_messenger_user_id
    )
  end

  private

  def messenger_gateway
    case @delivery.recipient_messenger
    when 'telegram' then Gateways::Telegram
    else raise 'dummy dumb'
    end
  end
end
