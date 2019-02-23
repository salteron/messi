require 'rails_helper'

describe Result do
  let(:work_result) { described_class.new(payload, errors) }
  let(:payload) { double }
  let(:errors) { [] }

  context 'when errors are present' do
    let(:errors) { [double] }
    it { expect(work_result).not_to be_success }
    it { expect(work_result).to be_failure }
  end

  context 'when errors are blank' do
    it { expect(work_result).to be_success }
    it { expect(work_result).not_to be_failure }
  end
end
