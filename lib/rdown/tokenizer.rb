# frozen_string_literal: true

require 'strscan'

module Rdown
  class Tokenizer
    METHOD_NAME_IDENTIFIER_PATTERN = %r{
      (?:
        (?!\d)(?:\w|[^[:ascii:]])+[!?=]?
          | -
          | !
          | !=
          | !~
          | \[\]
          | \[\]=
          | \*
          | \*\*
          | /
          | \+
          | \|
          | &
          | %
          | ^
          | <
          | <<
          | <=
          | <=>
          | ==
          | ===
          | =>
          | =~
          | >
          | >>
          | ~
      )
    }x.freeze

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
        when on_beginning_of_line? && peek(3) == '---'
          tokenize_method_signature
        when on_beginning_of_line? && peek(2) == '=='
          consume_line_beginning_double_equal
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
        when match?(/Class Methods/)
          consume_class_methods
        when match?(/Instance Methods/)
          consume_instance_methods
        when match?(/class/)
          consume_class
        when match?(/\S/)
          consume_word
        else
          raise
        end
      end
      tokens
    end

    private

    def consume_arrow_right
      pointer = scanner.pointer
      scanner.pointer += '->'.bytesize
      tokens << ::Rdown::Tokens::ArrowRight.new(
        pointer: pointer,
      )
    end

    def consume_asterisk
      pointer = scanner.pointer
      scanner.pointer += '*'.bytesize
      tokens << ::Rdown::Tokens::Asterisk.new(
        pointer: pointer,
      )
    end

    def consume_bracket_left
      pointer = scanner.pointer
      scanner.pointer += '['.bytesize
      tokens << ::Rdown::Tokens::BracketLeft.new(
        pointer: pointer,
      )
    end

    def consume_bracket_right
      pointer = scanner.pointer
      scanner.pointer += ']'.bytesize
      tokens << ::Rdown::Tokens::BracketRight.new(
        pointer: pointer,
      )
    end

    def consume_class
      pointer = scanner.pointer
      scanner.pointer += 'class'.bytesize
      tokens << ::Rdown::Tokens::Class.new(
        pointer: pointer,
      )
    end

    def consume_class_methods
      pointer = scanner.pointer
      scanner.pointer += 'Class Methods'.bytesize
      tokens << ::Rdown::Tokens::ClassMethods.new(
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

    def consume_identifier
      pointer = scanner.pointer
      content = scan(METHOD_NAME_IDENTIFIER_PATTERN)
      tokens << ::Rdown::Tokens::Identifier.new(
        content: content,
        pointer: pointer,
      )
    end

    def consume_instance_methods
      pointer = scanner.pointer
      scanner.pointer += 'Instance Methods'.bytesize
      tokens << ::Rdown::Tokens::InstanceMethods.new(
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

    def consume_line_beginning_double_equal
      pointer = scanner.pointer
      scanner.pointer += '=='.bytesize
      tokens << ::Rdown::Tokens::LineBeginningDoubleEqual.new(
        pointer: pointer,
      )
    end

    def consume_line_beginning_triple_hyphen
      pointer = scanner.pointer
      scanner.pointer += '---'.bytesize
      tokens << ::Rdown::Tokens::LineBeginningTripleHyphen.new(
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

    def consume_parenthesis_left
      pointer = scanner.pointer
      scanner.pointer += '('.bytesize
      tokens << ::Rdown::Tokens::ParenthesisLeft.new(
        pointer: pointer,
      )
    end

    def consume_parenthesis_right
      pointer = scanner.pointer
      scanner.pointer += ')'.bytesize
      tokens << ::Rdown::Tokens::ParenthesisRight.new(
        pointer: pointer,
      )
    end

    def consume_pipe
      pointer = scanner.pointer
      scanner.pointer += '|'.bytesize
      tokens << ::Rdown::Tokens::Pipe.new(
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

    def tokenize_method_signature
      until peek(1) == "\n"
        case
        when on_beginning_of_line? && peek(3) == '---'
          consume_line_beginning_triple_hyphen
        when peek(1) == ' '
          skip_spaces
        when peek(1) == '*'
          consume_asterisk
        when peek(1) == '{'
          consume_brace_left
        when peek(1) == '}'
          consume_brace_right
        when peek(1) == '['
          consume_bracket_left
        when peek(1) == ']'
          consume_bracket_right
        when peek(1) == '('
          consume_parenthesis_left
        when peek(1) == ')'
          consume_parenthesis_right
        when peek(1) == ','
          consume_comma
        when peek(1) == '|'
          consume_pipe
        when peek(3) == '...'
          consume_triple_dot
        when peek(2) == '->'
          consume_arrow_right
        else
          consume_identifier
        end
      end
    end

    # @return [Array<Rdown::Tokens::Base>]
    def tokens
      @tokens ||= []
    end
  end
end
