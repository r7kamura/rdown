# frozen_string_literal: true

RSpec.describe Rdown::Tokenizer do
  describe '.call' do
    subject do
      described_class.call(pre_processed_lines)
    end

    let(:pre_processed_lines) do
      Rdown::PreProcessor.call(source)
    end

    context 'with class line' do
      let(:source) do
        <<~RD
          = class Array < Object
        RD
      end

      it 'returns expected tokens' do
        is_expected.to be_as_json(
          [
            hash_including(
              type: 'LineBeginningEqual',
            ),
            hash_including(
              type: 'Class',
            ),
            hash_including(
              content: 'Array',
              type: 'Word',
            ),
            hash_including(
              type: 'LessThan',
            ),
            hash_including(
              content: 'Object',
              type: 'Word',
            ),
            hash_including(
              type: 'LineBreak',
            ),
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
        is_expected.to be_as_json(
          [
            hash_including(
              type: 'Param',
            ),
            hash_including(
              content: 'pattern',
              type: 'Identifier',
            ),
            hash_including(
              content: '検索するパターンです。',
              type: 'Word',
            ),
            hash_including(
              type: 'LineBreak',
            ),
            hash_including(
              type: 'Param',
            ),
            hash_including(
              content: 'pos',
              type: 'Identifier',
            ),
            hash_including(
              content: '検索を始めるインデックスです。',
              type: 'Word',
            ),
            hash_including(
              type: 'LineBreak',
            ),
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
        is_expected.to be_as_json(
          [
            a_hash_including(
              type: 'Word'
            ),
            a_hash_including(
              type: 'LineBreak'
            ),
            a_hash_including(
              type: 'LineBreak'
            ),
            a_hash_including(
              content: '[1, 2, 3]',
              type: 'Code',
            ),
            a_hash_including(
              type: 'LineBreak'
            ),
            a_hash_including(
              type: 'LineBreak'
            ),
            a_hash_including(
              type: 'Word'
            ),
            a_hash_including(
              type: 'LineBreak'
            ),
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
        is_expected.to be_as_json(
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
        is_expected.to be_as_json(
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
        is_expected.to be_as_json(
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
        is_expected.to be_as_json(
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

    context 'with #@since' do
      let(:source) do
        <<~'RD'
          #@since 1.9.1
          #@end
        RD
      end

      it 'returns expected tokens' do
        is_expected.to eq([])
      end
    end

    context 'with #@until' do
      let(:source) do
        <<~'RD'
          #@until 1.9.1
          #@end
        RD
      end

      it 'returns expected tokens' do
        is_expected.to eq([])
      end
    end
  end
end
