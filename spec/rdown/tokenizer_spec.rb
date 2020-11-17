# frozen_string_literal: true

RSpec.describe Rdown::Tokenizer do
  describe '.call' do
    subject do
      described_class.call(source)
    end

    let(:source) do
      ''
    end

    it 'does not raise error' do
      subject
    end
  end
end
