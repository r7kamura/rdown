# frozen_string_literal: true

RSpec.describe Rdown::Tokenizer do
  describe '.call' do
    subject do
      described_class.call(source)
    end

    context 'with class line' do
      let(:source) do
        <<~RD
          = class Array < Object
        RD
      end

      it 'returns expected tokens' do
        is_expected.to eq(
          [
            {
              pointer: 0,
              type: :line_beginning_equal,
            },
            {
              pointer: 1,
              type: :spaces,
            },
            {
              pointer: 2,
              type: :class,
            },
            {
              pointer: 7,
              type: :spaces,
            },
            {
              content: 'Array',
              pointer: 8,
              type: :word,
            },
            {
              pointer: 13,
              type: :spaces,
            },
            {
              pointer: 14,
              type: :less_than,
            },
            {
              pointer: 15,
              type: :spaces,
            },
            {
              content: 'Object',
              pointer: 16,
              type: :word,
            },
            {
              pointer: 22,
              type: :line_break,
            },
          ]
        )
      end
    end

    context 'with parameter lines' do
      let(:source) do
        <<~RD
          @param pattern 検索するパターンです。
          @param pos 検索を始めるインデックスです。
        RD
      end

      it 'returns expected tokens' do
        is_expected.to eq(
          [
            {
              content: 'param',
              pointer: 0,
              type: :keyword,
            },
            {
              pointer: 6,
              type: :spaces,
            },
            {
              content: 'pattern',
              pointer: 7,
              type: :word,
            },
            {
              pointer: 14,
              type: :spaces,
            },
            {
              content: '検索するパターンです。',
              pointer: 15,
              type: :word,
            },
            {
              pointer: 48,
              type: :line_break,
            },
            {
              content: 'param',
              pointer: 49,
              type: :keyword,
            },
            {
              pointer: 55,
              type: :spaces,
            },
            {
              content: 'pos',
              pointer: 56,
              type: :word,
            },
            {
              pointer: 59,
              type: :spaces,
            },
            {
              content: '検索を始めるインデックスです。',
              pointer: 60,
              type: :word,
            },
            {
              pointer: 105,
              type: :line_break,
            },
          ]
        )
      end
    end
  end
end
