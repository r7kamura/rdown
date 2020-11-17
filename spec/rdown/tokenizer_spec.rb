# frozen_string_literal: true

RSpec.describe Rdown::Tokenizer do
  describe '.call' do
    subject do
      described_class.call(source)
    end

    context 'with single parameter line' do
      let(:source) do
        <<~RD
          @param pattern 検索するパターンです。
          @param pos 検索を始めるインデックスです。
        RD
      end

      it 'returns tokens' do
        is_expected.to eq(
          [
            {
              content: 'param',
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
            },
            {
              pointer: 14,
              type: 'spaces',
            },
            {
              content: '検索するパターンです。',
              pointer: 15,
              type: 'word',
            },
            {
              pointer: 48,
              type: 'line_break',
            },
            {
              content: 'param',
              pointer: 49,
              type: 'keyword',
            },
            {
              pointer: 55,
              type: 'spaces',
            },
            {
              content: 'pos',
              pointer: 56,
              type: 'word',
            },
            {
              pointer: 59,
              type: 'spaces',
            },
            {
              content: '検索を始めるインデックスです。',
              pointer: 60,
              type: 'word',
            },
            {
              pointer: 105,
              type: 'line_break',
            },
          ]
        )
      end
    end
  end
end
