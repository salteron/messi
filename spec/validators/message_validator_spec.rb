# frozen_string_literal: true

require 'rails_helper'

describe MessageValidator do
  let(:result) { described_class.call(params) }
  let(:params) { {} }

  describe 'text validation' do
    context 'when non-empty' do
      let(:params) { {text: 'Hello, World!'} }
      it { expect(result.errors[:text]).to be_nil }
    end

    context 'when not specified' do
      it { expect(result).to be_failure }
      it { expect(result.errors[:text]).to contain_exactly('is missing') }
    end

    context 'when nil' do
      let(:params) { {text: nil} }
      it { expect(result).to be_failure }
      it { expect(result.errors[:text]).to contain_exactly('must be filled') }
    end

    context 'when empty' do
      let(:params) { {text: ''} }
      it { expect(result).to be_failure }
      it { expect(result.errors[:text]).to contain_exactly('must be filled') }
    end

    context 'when exceeds max length' do
      let(:params) { {text: text} }
      let(:text) { 'a' * 1001 }

      it { expect(result).to be_failure }
      it do
        expect(result.errors[:text]).to \
          contain_exactly('size cannot be greater than 1000')
      end
    end
  end

  describe 'send_at validation' do
    context 'when datetime' do
      let(:params) { {send_at: Time.zone.now.to_s} }
      it { expect(result.errors[:send_at]).to be_nil }
    end

    context 'when not specified' do
      it { expect(result.errors[:send_at]).to be_nil }
    end

    context 'when nil' do
      let(:params) { {send_at: nil} }
      it { expect(result.errors[:send_at]).to be_nil }
    end

    context 'when not datetime' do
      let(:params) { {send_at: '>_<'} }

      it do
        expect(result.errors[:send_at]).to \
          contain_exactly('must be a date time')
      end
    end
  end

  describe 'recipients validation' do
    context 'when contains non-empty values' do
      let(:params) do
        {
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

      it { expect(result.errors[:recipients]).to be_nil }
    end

    context 'when contains invalid values' do
      let(:params) do
        {
          recipients: [
            {
              messenger: 'telegram',
              messenger_user_id: ''
            },
            {
              messenger: '',
              messenger_user_id: '@trump'
            },
            {
            },
            {
              messenger: 'unknown-messenger',
              messenger_user_id: '47'
            },
            {
              messenger: 'telegram',
              messenger_user_id: 'a' * 256
            }
          ]
        }
      end

      it do
        expect(result.errors[:recipients]).to match_array(
          [
            [0, {messenger_user_id: ['must be filled']}],
            [1, {messenger: ['must be filled']}],
            [2, {
              messenger: ['is missing'],
              messenger_user_id: ['is missing']
            }],
            [3, {messenger: ['must be one of: telegram']}],
            [4, {messenger_user_id: ['size cannot be greater than 255']}]
          ]
        )
      end
    end

    context 'when not specified' do
      it { expect(result.errors[:recipients]).to contain_exactly('is missing') }
    end

    context 'when not an array' do
      let(:params) { {recipients: 42} }

      it do
        expect(result.errors[:recipients]).to \
          contain_exactly('must be an array')
      end
    end
  end

  describe 'message uniqueness validation' do
    let(:message) { create(:message, text: 'Hello, World!') }

    before do
      create(:delivery, message: message, recipient_messenger: :telegram,
                        recipient_messenger_user_id: '@donald')
    end

    let(:params) do
      {
        text: 'Hello, World!',
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

    it do
      expect(result.errors[:text_uniqueness]).to \
        contain_exactly('(text, recipient) is not unique')
    end
  end
end
