FactoryBot.define do
  factory :delivery do
    association :message
    message_text_md5 { Digest::MD5.hexdigest(message.text) }
    recipient_messenger { :telegram }
    sequence(:recipient_messenger_user_id) { |n| "@president-#{n}" }
  end
end
