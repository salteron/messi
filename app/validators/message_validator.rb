# frozen_string_literal: true

MAX_TEXT_LENGTH = 1000
MAX_MESSENGER_USER_ID_LENGTH = 255
CUSTOM_ERROR_MESSAGES = {
  en: {errors: {text_uniqueness: '(text, recipient) is not unique'}}
}.freeze

validate_recipients_text_uniq = proc do |recipients, text|
  text_md5 = Digest::MD5.hexdigest(text)

  recipients.none? do |recipient|
    Delivery.where(
      recipient_messenger_user_id: recipient[:messenger_user_id],
      recipient_messenger: recipient[:messenger],
      message_text_md5: text_md5
    ).exists?
  end
end

RecipientValidator = Dry::Validation.Params do
  required(:messenger)
    .filled(:str?, included_in?: Delivery.recipient_messengers.keys)

  required(:messenger_user_id)
    .filled(:str?, max_size?: MAX_MESSENGER_USER_ID_LENGTH)
end

MessageValidator = Dry::Validation.Params do
  configure do
    def self.messages
      super.merge(CUSTOM_ERROR_MESSAGES)
    end
  end

  required(:text).filled(:str?, max_size?: MAX_TEXT_LENGTH)
  optional(:send_at).maybe(:date_time?)

  required(:recipients).each { schema(RecipientValidator) }

  validate(text_uniqueness: %i[recipients text], &validate_recipients_text_uniq)
end
