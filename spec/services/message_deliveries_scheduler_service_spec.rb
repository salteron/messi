# frozen_string_literal: true

require 'rails_helper'

describe MessageDeliveriesSchedulerService do
  let(:schedule_deliveries) { scheduler.schedule_deliveries }
  let(:scheduler) { described_class.new(message) }
  let(:send_at) { nil }
  let(:message) { create(:message, text: 'Hello, World!', send_at: send_at) }
  let!(:delivery_1) { create(:delivery, message: message) }
  let!(:delivery_2) { create(:delivery, message: message) }

  before { schedule_deliveries }

  it { expect(DeliveryJob.jobs.size).to eq(2) }
  it { expect(DeliveryJob).to have_enqueued_sidekiq_job(delivery_1.id) }
  it { expect(DeliveryJob).to have_enqueued_sidekiq_job(delivery_2.id) }
  it { expect(DeliveryJob.jobs).not_to include(have_key('at')) }

  context 'when send_at is specified' do
    let(:send_at) { Time.zone.parse('2020-01-01 12:00:00') }
    it { expect(DeliveryJob.jobs).to all(include('at' => send_at.to_f)) }
  end
end
