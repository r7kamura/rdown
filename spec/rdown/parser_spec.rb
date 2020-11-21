# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/json'

RSpec.describe Rdown::Parser do
  describe '.call' do
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
          class_methods: [],
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
          instance_methods: [],
          type: 'Class',
        )
      end
    end

    context 'with instance methods' do
      let(:source) do
        <<~RD
          = class Array < Object

          == Instance Methods

          --- [](nth)    -> object | nil
          --- at(nth)    -> object | nil

          nth 番目の要素を返します。nth 番目の要素が存在しない時には nil を返します。

          @param item 配列の要素を指定します。
        RD
      end

      it 'returns expected node' do
        is_expected.to eq(
          class_methods: [],
          description: [],
          heading: {
            name: 'Array',
            parent_name: 'Object',
            type: 'ClassHeading',
          },
          instance_methods: [
            {
              description: [
                {
                  content: 'nth 番目の要素を返します。nth 番目の要素が存在しない時には nil を返します。',
                  type: 'Paragraph',
                },
              ],
              parameters: [
                {
                  description: '配列の要素を指定します。',
                  name: 'item',
                  type: 'MethodParameter',
                },
              ],
              signatures: [
                {
                  name: '[]',
                  type: 'MethodSignature',
                },
                {
                  name: 'at',
                  type: 'MethodSignature',
                },
              ],
              type: 'Method',
            },
          ],
          type: 'Class',
        )
      end
    end

    context 'with class methods' do
      let(:source) do
        <<~RD
          = class Array < Object

          == Class Methods

          --- try_convert(obj) -> Array | nil

          to_ary メソッドを用いて obj を配列に変換しようとします。

          何らかの理由で変換できないときには nil を返します。
          このメソッドは引数が配列であるかどうかを調べるために使えます。

          --- [](*item)    -> Array

          引数 item を要素として持つ配列を生成して返します。
        RD
      end

      it 'returns expected node' do
        is_expected.to eq(
          class_methods: [
            {
              description: [
                {
                  content: 'to_ary メソッドを用いて obj を配列に変換しようとします。',
                  type: 'Paragraph',
                },
                {
                  content: '何らかの理由で変換できないときには nil を返します。 このメソッドは引数が配列であるかどうかを調べるために使えます。',
                  type: 'Paragraph',
                },
              ],
              parameters: [],
              signatures: [
                {
                  name: 'try_convert',
                  type: 'MethodSignature',
                },
              ],
              type: 'Method',
            },
            {
              description: [
                {
                  content: '引数 item を要素として持つ配列を生成して返します。',
                  type: 'Paragraph',
                },
              ],
              parameters: [],
              signatures: [
                {
                  name: '[]',
                  type: 'MethodSignature',
                },
              ],
              type: 'Method',
            },
          ],
          description: [],
          heading: {
            name: 'Array',
            parent_name: 'Object',
            type: 'ClassHeading',
          },
          instance_methods: [],
          type: 'Class',
        )
      end
    end
  end
end
