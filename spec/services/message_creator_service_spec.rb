require 'rails_helper'

describe MessageCreatorService do
  let(:message) { result.payload }
  let(:errors) { result.errors }
  let(:result) { create_message }
  let(:create_message) { service.create! }
  let(:service) { described_class.new(params) }
  let(:params) do
    {
      text: 'Hello, World!',
      send_at: send_at.to_s,
      recipients: [
        {
          messenger: 'telegram',
          messenger_user_id: '@donald'
        },
        {
          messenger: 'telegram',
          messenger_user_id: '@trump'
        }
      ]
    }
  end
  let(:send_at) { Time.zone.parse('2020-01-01') }

  context 'when successfully creates a message' do
    it { expect { create_message }.to change(Message, :count).by(1) }

    describe 'created message' do
      it do
        expect(message).to have_attributes(
          text: 'Hello, World!',
          send_at: send_at
        )
      end
    end

    describe 'created and scheduled deliveries' do
      before { create_message }

      it { expect(message.deliveries.size).to be(2) }

      let(:delivery_to_donald) do
        message.deliveries.find_by!(recipient_messenger_user_id: '@donald')
      end

      let(:delivery_to_trump) do
        message.deliveries.find_by!(recipient_messenger_user_id: '@trump')
      end

      it do
        expect(delivery_to_donald).to have_attributes(
          message: message,
          message_text_md5: '65a8e27d8879283831b664bd8b7f0ad4',
          recipient_messenger: 'telegram',
          recipient_messenger_user_id: '@donald'
        )
      end

      it do
        expect(delivery_to_trump).to have_attributes(
          message: message,
          message_text_md5: '65a8e27d8879283831b664bd8b7f0ad4',
          recipient_messenger: 'telegram',
          recipient_messenger_user_id: '@trump'
        )
      end

      it { expect(DeliveryJob.jobs.size).to eq(2) }

      it do
        expect(DeliveryJob).to have_enqueued_sidekiq_job(delivery_to_donald.id)
      end

      it do
        expect(DeliveryJob).to have_enqueued_sidekiq_job(delivery_to_trump.id)
      end

      it do
        expect(DeliveryJob.jobs).to all(include('at' => send_at.to_f))
      end
    end
  end

  context 'when fails to save to db' do
    before { allow(Delivery).to receive(:create!).and_raise('lost') }

    it do
      expect { create_message }.to raise_error do |_|
        expect(Message.count).to be_zero
        expect(Delivery.count).to be_zero
        expect(DeliveryJob.jobs.size).to be_zero
      end
    end
  end

  context 'when fails to schedule delivery' do
    before { allow(DeliveryJob).to receive(:perform_at).and_raise('lost') }

    it do
      expect { create_message }.to raise_error do |_|
        expect(Message.count).to be_zero
        expect(Delivery.count).to be_zero
        expect(DeliveryJob.jobs.size).to be_zero
      end
    end
  end

  context 'when validation fails' do
    let(:params) do
      {
        text: '',
        send_at: send_at.to_s,
        recipients: [
          {
            messenger: 'telegram',
            messenger_user_id: '@donald'
          }
        ]
      }
    end

    it { expect(errors).to eq(text: ['must be filled']) }
  end

  context 'when concurrent message with the same text to the same recipient' do
    let(:params) do
      {
        text: 'Hello, World!',
        recipients: [
          {
            messenger: 'telegram',
            messenger_user_id: '@donald'
          }
        ]
      }
    end

    before do
      allow_any_instance_of(ActiveRecord::Relation).to \
        receive(:exists?).and_wrap_original do |original, *args|

        exists = original.call(*args)

        unless exists
          concurrent_message = create(:message, text: 'Hello, World!')
          create(:delivery,
                 message: concurrent_message,
                 recipient_messenger: 'telegram',
                 recipient_messenger_user_id: '@donald')
        end

        exists
      end
    end

    it do
      expect(result.errors[:text_uniqueness]).to \
        contain_exactly('(text, recipient) is not unique')
    end
  end
end
