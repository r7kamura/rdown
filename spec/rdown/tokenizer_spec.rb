# frozen_string_literal: true

RSpec.describe Rdown::Tokenizer do
  describe '.call' do
    subject do
      described_class.call(source)
    end

    let(:source) do
      <<~RD
        @param pattern  検索するパターンです。
        @param pos      検索を始めるインデックスです。
      RD
    end

    context 'with single parameter line' do
      let(:source) do
        <<~RD
          @param pattern 検索するパターンです。
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
          ]
        )
      end
    end
  end
end
