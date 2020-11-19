# frozen_string_literal: true

require 'strscan'

module Rdown
  class Tokenizer
    class << self
      # @param [String] source
      # @return [Array<Rdown::Tokens::Base>]
      def call(source)
        new(source).call
      end
    end

    # @param [String] source
    def initialize(source)
      @source = source
    end

    # @return [Array<Rdown::Tokens::Base>]
    def call
      until on_eos?
        case
        when on_beginning_of_line? && peek(1) == '='
          consume_line_beginning_equal
        when on_beginning_of_line? && peek(1) == '@'
          consume_keyword
        when on_beginning_of_line? && peek(2) == '  '
          consume_code
        when peek(1) == "\n"
          consume_line_break
        when peek(1) == ' '
          skip_spaces
        when peek(1) == '<'
          consume_less_than
        when match?(/\Aclass\b/)
          consume_class
        else
          consume_word
        end
      end
      tokens
    end

    private

    def consume_class
      pointer = scanner.pointer
      scanner.pointer += 'class'.bytesize
      tokens << ::Rdown::Tokens::Class.new(
        pointer: pointer,
      )
    end

    def consume_code
      pointer = scanner.pointer
      scanner.pointer += '  '.bytesize
      content = scan(/.+$/)
      tokens << ::Rdown::Tokens::Code.new(
        content: content,
        pointer: pointer,
      )
    end

    def consume_keyword
      pointer = scanner.pointer
      scanner.pointer += '@'.bytesize
      content = scan(/\w+/)
      tokens << ::Rdown::Tokens::Keyword.new(
        content: content,
        pointer: pointer,
      )
    end

    def consume_less_than
      pointer = scanner.pointer
      scanner.pointer += '<'.bytesize
      tokens << ::Rdown::Tokens::LessThan.new(
        pointer: pointer,
      )
    end

    def consume_line_beginning_equal
      pointer = scanner.pointer
      scanner.pointer += '='.bytesize
      tokens << ::Rdown::Tokens::LineBeginningEqual.new(
        pointer: pointer,
      )
    end

    def consume_line_break
      pointer = scanner.pointer
      scanner.pointer += "\n".bytesize
      tokens << ::Rdown::Tokens::LineBreak.new(
        pointer: pointer,
      )
    end

    def consume_word
      pointer = scanner.pointer
      content = scan(/\S+/)
      tokens << ::Rdown::Tokens::Word.new(
        content: content,
        pointer: pointer,
      )
    end

    def match?(*args)
      scanner.match?(*args)
    end

    # @return [Boolean]
    def on_beginning_of_line?
      scanner.beginning_of_line?
    end

    # @return [Boolean]
    def on_eos?
      scanner.eos?
    end

    def peek(*args)
      scanner.peek(*args)
    end

    def scan(*args)
      scanner.scan(*args)
    end

    # @return [StringScanner]
    def scanner
      @scanner ||= ::StringScanner.new(@source)
    end

    def skip_spaces
      scan(/ +/)
    end

    # @return [Array<Rdown::Tokens::Base>]
    def tokens
      @tokens ||= []
    end
  end
end
