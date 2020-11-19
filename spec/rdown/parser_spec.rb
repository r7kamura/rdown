# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/json'

RSpec.describe Rdown::Parser do
  describe '.class' do
    subject do
      described_class.call(tokens).as_json.deep_symbolize_keys
    end

    let(:tokens) do
      Rdown::Tokenizer.call(source)
    end

    context 'with class name less tokens' do
      let(:source) do
        <<~RD
          = class
        RD
      end

      it do
        expect { subject }.to raise_error(Rdown::Errors::UnexpectedTokenTypeError)
      end
    end

    context 'with class description' do
      let(:source) do
        <<~RD
          = class Array < Object

          配列クラスです。
          配列は任意の Ruby オブジェクトを要素として持つことができます。

          一般的には配列は配列式を使って

            [1, 2, 3]

          のように生成します。
        RD
      end

      it 'returns expected node' do
        is_expected.to eq(
          description: [
            {
              content: '配列クラスです。 配列は任意の Ruby オブジェクトを要素として持つことができます。',
              type: 'Paragraph',
            },
            {
              content: '一般的には配列は配列式を使って',
              type: 'Paragraph',
            },
            {
              content: '[1, 2, 3]',
              type: 'CodeBlock',
            },
            {
              content: 'のように生成します。',
              type: 'Paragraph',
            },
          ],
          heading: {
            name: 'Array',
            parent_name: 'Object',
            type: 'ClassHeading',
          },
          type: 'Class',
        )
      end
    end
  end
end
