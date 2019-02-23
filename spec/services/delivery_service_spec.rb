require 'rails_helper'

describe DeliveryService do
  let(:deliver) { service.perform }
  let(:service) { described_class.new(delivery) }
  let(:delivery) { build_stubbed(:delivery, recipient_messenger: :telegram) }

  it { expect(deliver).to be true }
end
