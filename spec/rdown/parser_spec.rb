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

          @raise TypeError 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                           指定した場合に発生します。
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
              exceptions: [],
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
              version_since: nil,
              version_until: nil,
            },
          ],
          type: 'Class',
        )
      end
    end

    context 'with class methods' do
      let(:source) do
        <<~'RD'
          = class Array < Object

          == Class Methods

          #@since 1.9.1

          --- try_convert(obj) -> Array | nil

          to_ary メソッドを用いて obj を配列に変換しようとします。

          何らかの理由で変換できないときには nil を返します。
          このメソッドは引数が配列であるかどうかを調べるために使えます。

          #@end

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
              exceptions: [],
              parameters: [],
              signatures: [
                {
                  name: 'try_convert',
                  type: 'MethodSignature',
                },
              ],
              type: 'Method',
              version_since: '1.9.1',
              version_until: nil,
            },
            {
              description: [
                {
                  content: '引数 item を要素として持つ配列を生成して返します。',
                  type: 'Paragraph',
                },
              ],
              exceptions: [],
              parameters: [],
              signatures: [
                {
                  name: '[]',
                  type: 'MethodSignature',
                },
              ],
              type: 'Method',
              version_since: nil,
              version_until: nil,
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

    context 'with multi-line code blocks separated by empty line' do
      let(:source) do
        <<~RD
          = class Array < Object

          == Class Methods

          --- try_convert(obj) -> Array | nil

            Array.try_convert([1])   # => [1]
            Array.try_convert("1")   # => nil

            if tmp = Array.try_convert(arg)
              # the argument is an array
            elsif tmp = String.try_convert(arg)
              # the argument is a string
            end
        RD
      end

      it 'returns expected node' do
        is_expected.to match(
          a_hash_including(
            class_methods: [
              a_hash_including(
                description: [
                  a_hash_including(
                    type: 'CodeBlock',
                  ),
                ]
              ),
            ],
          )
        )
      end
    end
  end
end
