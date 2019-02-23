# frozen_string_literal: true

require 'rails_helper'

describe MessagesController, type: :request do
  describe '#create' do
    context 'when valid params' do
      let(:params) do
        {
          text: 'Hello, World!',
          recipients: [
            {
              messenger: 'telegram',
              messenger_user_id: '@trump'
            }
          ]
        }
      end

      before { post '/messages', params: params }

      it { expect(response).to have_http_status(:created) }
      it { expect(JSON.parse(response.body)).to eq('id' => Message.last.id) }
    end

    context 'when invalid params' do
      let(:params) do
        {
          recipients: [
            {
              messenger: 'telegram',
              messenger_user_id: ''
            }
          ]
        }
      end

      before { post '/messages', params: params }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it do
        expect(JSON.parse(response.body)).to eq(
          'recipients' => {'0' => {'messenger_user_id' => ['must be filled']}},
          'text' => ['is missing']
        )
      end
    end
  end
end
