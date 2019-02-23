# frozen_string_literal: true

class MessageCreatorService
  def initialize(params)
    @params = params
  end

  def create!
    validate do
      ApplicationRecord.transaction do
        create_message!.tap do |message|
          create_message_deliveries!(message)
          schedule_message_deliveries(message)
        end
      end
    end
  rescue *ErrorsGroups::UNIQUE_VIOLATION_ERRORS
    retry
  end

  private

  def validate
    validation_result = MessageValidator.call(@params)

    if validation_result.success?
      Result.new(yield)
    else
      Result.new(nil, validation_result.errors)
    end
  end

  def create_message!
    Message.create!(
      text: @params.fetch(:text),
      send_at: @params[:send_at]
    )
  end

  def create_message_deliveries!(message)
    @params.fetch(:recipients).each do |recipient|
      Delivery.create!(
        message: message,
        recipient_messenger: recipient.fetch(:messenger),
        recipient_messenger_user_id: recipient.fetch(:messenger_user_id),
        message_text_md5: Digest::MD5.hexdigest(message.text)
      )
    end
  end

  def schedule_message_deliveries(message)
    MessageDeliveriesSchedulerService.new(message).schedule_deliveries
  end
end
