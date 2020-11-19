# frozen_string_literal: true

RSpec.describe Rdown::Parser do
  describe '.class' do
    subject do
      described_class.call(tokens)
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

      it 'raises' do
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

      it 'return expected node' do
        is_expected.to eq(
          descriptions: [
            {
              content: '配列クラスです。 配列は任意の Ruby オブジェクトを要素として持つことができます。',
              type: :description,
            },
            {
              content: '一般的には配列は配列式を使って',
              type: :description,
            },
            {
              content: '[1, 2, 3]',
              type: :code_block,
            },
            {
              content: 'のように生成します。',
              type: :description,
            },
          ],
          name: 'Array',
          parent_name: 'Object',
          type: :class
        )
      end
    end
  end
end
