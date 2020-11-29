# frozen_string_literal: true

RSpec.describe Rdown::Parser do
  describe '.call' do
    subject do
      described_class.call(tokens)
    end

    let(:pre_processed_source) do
      Rdown::PreProcessor.call(source)
    end

    let(:tokens) do
      Rdown::Tokenizer.call(**pre_processed_source)
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
        is_expected.to be_as_json(
          a_hash_including(
            class_methods: [],
            description: [
              a_hash_including(
                content: '配列クラスです。 配列は任意の Ruby オブジェクトを要素として持つことができます。',
                type: 'Paragraph',
              ),
              a_hash_including(
                content: '一般的には配列は配列式を使って',
                type: 'Paragraph',
              ),
              a_hash_including(
                content: '[1, 2, 3]',
                type: 'CodeBlock',
              ),
              a_hash_including(
                content: 'のように生成します。',
                type: 'Paragraph',
              ),
            ],
            heading: a_hash_including(
              name: 'Array',
              parent_name: 'Object',
              type: 'ClassHeading',
            ),
            instance_methods: [],
            type: 'Class',
          )
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
        is_expected.to be_as_json(
          a_hash_including(
            class_methods: [],
            description: [],
            heading: a_hash_including(
              name: 'Array',
              parent_name: 'Object',
              type: 'ClassHeading',
            ),
            instance_methods: [
              a_hash_including(
                description: [
                  a_hash_including(
                    content: 'nth 番目の要素を返します。nth 番目の要素が存在しない時には nil を返します。',
                    type: 'Paragraph',
                  ),
                ],
                parameters: [
                  a_hash_including(
                    description: '配列の要素を指定します。',
                    name: 'item',
                    type: 'MethodParameter',
                  ),
                ],
                signatures: [
                  a_hash_including(
                    method_name: '[]',
                    type: 'MethodSignature',
                  ),
                  a_hash_including(
                    method_name: 'at',
                    type: 'MethodSignature',
                  ),
                ],
                type: 'Method',
              ),
            ],
            type: 'Class',
          )
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
        is_expected.to be_as_json(
          a_hash_including(
            class_methods: [
              a_hash_including(
                description: [
                  a_hash_including(
                    content: 'to_ary メソッドを用いて obj を配列に変換しようとします。',
                    type: 'Paragraph',
                  ),
                  a_hash_including(
                    content: '何らかの理由で変換できないときには nil を返します。 このメソッドは引数が配列であるかどうかを調べるために使えます。',
                    type: 'Paragraph',
                  ),
                ],
                parameters: [],
                signatures: [
                  a_hash_including(
                    method_name: 'try_convert',
                    position: {
                      column: 1,
                      line: 7,
                    },
                    type: 'MethodSignature',
                  ),
                ],
                type: 'Method',
              ),
              a_hash_including(
                description: [
                  a_hash_including(
                    content: '引数 item を要素として持つ配列を生成して返します。',
                    type: 'Paragraph',
                  ),
                ],
                parameters: [],
                signatures: [
                  a_hash_including(
                    method_name: '[]',
                    position: {
                      column: 1,
                      line: 16,
                    },
                    type: 'MethodSignature',
                  ),
                ],
                type: 'Method',
              ),
            ],
            description: [],
            heading: a_hash_including(
              name: 'Array',
              parent_name: 'Object',
              type: 'ClassHeading',
            ),
            instance_methods: [],
            position: {
              column: 1,
              line: 1,
            },
            type: 'Class',
          )
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

    context 'with example code after @param' do
      let(:source) do
        <<~'RD'
          = class Array < Object

          == Class Methods

          --- [](*item)    -> Array

          [[c:Array]] のサブクラスを作成したしたときに、そのサブクラスのインスタンスを作成
          しやすくするために用意されている。

          @param item 配列の要素を指定します。

            Array[1, 2, 3] #=> [1, 2, 3]

          --- new(size = 0, val = nil)    -> Array

          長さ size の配列を生成し、各要素を val で初期化して返します。
        RD
      end

      it 'returns expected node' do
        expect(subject.class_methods.count).to eq(2)
      end
    end
  end
end
