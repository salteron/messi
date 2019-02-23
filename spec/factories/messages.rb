FactoryBot.define do
  factory :message do
    sequence(:text) { |n| "Hello, #{n} Wordl!" }
  end
end
