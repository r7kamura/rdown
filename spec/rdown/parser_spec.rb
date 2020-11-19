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

    context 'with no inheritance class line' do
      let(:source) do
        <<~RD
          = class Array
        RD
      end

      it 'returns expected node' do
        is_expected.to eq(
          descriptions: [],
          name: 'Array',
          parent_name: nil,
          type: :class
        )
      end
    end

    context 'with inheritance class line' do
      let(:source) do
        <<~RD
          = class Array < Object
        RD
      end

      it 'returns expected node' do
        is_expected.to eq(
          descriptions: [],
          name: 'Array',
          parent_name: 'Object',
          type: :class
        )
      end
    end

    context 'with class description' do
      let(:source) do
        <<~RD
          = class Array < Object

          配列クラスです。
          配列は任意の Ruby オブジェクトを要素として持つことができます。
        RD
      end

      it 'return expected node' do
        is_expected.to eq(
          descriptions: [
            {
              content: '配列クラスです。 配列は任意の Ruby オブジェクトを要素として持つことができます。',
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
