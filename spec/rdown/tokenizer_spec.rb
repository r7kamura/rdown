# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/json'

RSpec.describe Rdown::Tokenizer do
  describe '.call' do
    subject do
      described_class.call(source).as_json.map(&:deep_symbolize_keys)
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
              type: 'LineBeginningEqual',
            },
            {
              pointer: 2,
              type: 'Class',
            },
            {
              content: 'Array',
              pointer: 8,
              type: 'Word',
            },
            {
              pointer: 14,
              type: 'LessThan',
            },
            {
              content: 'Object',
              pointer: 16,
              type: 'Word',
            },
            {
              pointer: 22,
              type: 'LineBreak',
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
              type: 'Keyword',
            },
            {
              content: 'pattern',
              pointer: 7,
              type: 'Word',
            },
            {
              content: '検索するパターンです。',
              pointer: 15,
              type: 'Word',
            },
            {
              pointer: 48,
              type: 'LineBreak',
            },
            {
              content: 'param',
              pointer: 49,
              type: 'Keyword',
            },
            {
              content: 'pos',
              pointer: 56,
              type: 'Word',
            },
            {
              content: '検索を始めるインデックスです。',
              pointer: 60,
              type: 'Word',
            },
            {
              pointer: 105,
              type: 'LineBreak',
            },
          ]
        )
      end
    end

    context 'with code block' do
      let(:source) do
        <<~RD
          一般的には配列は配列式を使って

            [1, 2, 3]

          のように生成します。
        RD
      end

      it 'returns expected tokens' do
        is_expected.to match(
          [
            a_hash_including(type: 'Word'),
            a_hash_including(type: 'LineBreak'),
            a_hash_including(type: 'LineBreak'),
            {
              content: '[1, 2, 3]',
              pointer: a_kind_of(Integer),
              type: 'Code',
            },
            a_hash_including(type: 'LineBreak'),
            a_hash_including(type: 'LineBreak'),
            a_hash_including(type: 'Word'),
            a_hash_including(type: 'LineBreak'),
          ]
        )
      end
    end

    context 'with instance methods' do
      let(:source) do
        <<~RD
          == Instance Methods
        RD
      end

      it 'returns expected tokens' do
        is_expected.to match(
          [
            a_hash_including(type: 'LineBeginningDoubleEqual'),
            a_hash_including(type: 'InstanceMethods'),
            a_hash_including(type: 'LineBreak'),
          ]
        )
      end
    end

    context 'with class methods' do
      let(:source) do
        <<~RD
          == Class Methods
        RD
      end

      it 'returns expected tokens' do
        is_expected.to match(
          [
            a_hash_including(type: 'LineBeginningDoubleEqual'),
            a_hash_including(type: 'ClassMethods'),
            a_hash_including(type: 'LineBreak'),
          ]
        )
      end
    end

    context 'with [] method' do
      let(:source) do
        <<~RD
          --- [](key) -> Object
        RD
      end

      it 'returns expected tokens' do
        is_expected.to match(
          [
            a_hash_including(type: 'LineBeginningTripleHyphen'),
            a_hash_including(type: 'BracketLeft'),
            a_hash_including(type: 'BracketRight'),
            a_hash_including(type: 'ParenthesisLeft'),
            a_hash_including(type: 'Identifier'),
            a_hash_including(type: 'ParenthesisRight'),
            a_hash_including(type: 'ArrowRight'),
            a_hash_including(type: 'Identifier'),
            a_hash_including(type: 'LineBreak'),
          ]
        )
      end
    end

    context 'with method line' do
      let(:source) do
        <<~RD
          --- try_convert(obj) -> Array | nil
        RD
      end

      it 'returns expected tokens' do
        is_expected.to match(
          [
            a_hash_including(type: 'LineBeginningTripleHyphen'),
            a_hash_including(type: 'Identifier'),
            a_hash_including(type: 'ParenthesisLeft'),
            a_hash_including(type: 'Identifier'),
            a_hash_including(type: 'ParenthesisRight'),
            a_hash_including(type: 'ArrowRight'),
            a_hash_including(type: 'Identifier'),
            a_hash_including(type: 'Pipe'),
            a_hash_including(type: 'Identifier'),
            a_hash_including(type: 'LineBreak'),
          ]
        )
      end
    end
  end
end
