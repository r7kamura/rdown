# frozen_string_literal: true

RSpec.describe Rdown::Tokenizer do
  describe '.call' do
    subject do
      described_class.call(source)
    end

    let(:source) do
      '@param pattern'
    end

    it 'returns tokens' do
      is_expected.to eq(
        [
          {
            name: 'param',
            pointer: 0,
            type: 'keyword',
          },
          {
            pointer: 6,
            type: 'spaces',
          },
          {
            content: 'pattern',
            pointer: 7,
            type: 'word',
          }
        ]
      )
    end
  end
end
