# frozen_string_literal: true

require 'strscan'

module Rdown
  class Tokenizer
    METHOD_NAME_IDENTIFIER_PATTERN = %r{
      (?:
        (?!\d)(?:\w|[^[:ascii:]])+[!?=]?
          | -
          | -@
          | !
          | !=
          | !~
          | \[\]
          | \[\]=
          | \*
          | \*\*
          | /
          | &
          | %
          | `
          | \^
          | \+
          | \+@
          | <
          | <<
          | <=
          | <=>
          | ==
          | ===
          | =~
          | >
          | >=
          | >>
          | \|
          | ~
      )
    }x.freeze

    class << self
      # @param [String] source
      # @param [Hash] source_map
      # @return [Array<Rdown::Tokens::Base>]
      def call(
        source:,
        source_map:
      )
        new(
          source: source,
          source_map: source_map,
        ).call
      end
    end

    # @param [String] source
    # @param [Hash] source_map
    def initialize(
      source:,
      source_map:
    )
      @position = ::Rdown::Position.new
      @source = source
      @source_map = source_map
    end

    # @return [Array<Rdown::Tokens::Base>]
    def call
      until at_eos?
        case
        when at_beginning_of_line? && peek(3) == '---'
          tokenize_method_signature
        when at_beginning_of_line? && peek(2) == '=='
          consume_line_beginning_double_equal
        when at_beginning_of_line? && peek(1) == '='
          consume_line_beginning_equal
        when at_beginning_of_line? && peek(6) == '@param'
          tokenize_method_parameter
        when at_beginning_of_line? && peek(2) == '  '
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

    # @return [Boolean]
    def at_beginning_of_line?
      scanner.beginning_of_line?
    end

    # @return [Boolean]
    def at_eos?
      scanner.eos?
    end

    def consume_arrow_right
      position = original_source_position
      scan('->')
      tokens << ::Rdown::Tokens::ArrowRight.new(
        position: position,
      )
    end

    def consume_asterisk
      position = original_source_position
      scan('*')
      tokens << ::Rdown::Tokens::Asterisk.new(
        position: position,
      )
    end

    def consume_bracket_left
      position = original_source_position
      scan('[')
      tokens << ::Rdown::Tokens::BracketLeft.new(
        position: position,
      )
    end

    def consume_bracket_right
      position = original_source_position
      scan(']')
      tokens << ::Rdown::Tokens::BracketRight.new(
        position: position,
      )
    end

    def consume_class
      position = original_source_position
      scan('class')
      tokens << ::Rdown::Tokens::Class.new(
        position: position,
      )
    end

    def consume_class_methods
      position = original_source_position
      scan('Class Methods')
      tokens << ::Rdown::Tokens::ClassMethods.new(
        position: position,
      )
    end

    def consume_code
      position = original_source_position
      content = scan(/  .*$/)
      tokens << ::Rdown::Tokens::Code.new(
        content: content[2..-1],
        position: position,
      )
    end

    def consume_identifier
      position = original_source_position
      content = scan(METHOD_NAME_IDENTIFIER_PATTERN)
      tokens << ::Rdown::Tokens::Identifier.new(
        content: content,
        position: position,
      )
    end

    def consume_instance_methods
      position = original_source_position
      scan('Instance Methods')
      tokens << ::Rdown::Tokens::InstanceMethods.new(
        position: position,
      )
    end

    def consume_less_than
      position = original_source_position
      scan('<')
      tokens << ::Rdown::Tokens::LessThan.new(
        position: position,
      )
    end

    def consume_line_beginning_double_equal
      position = original_source_position
      scan('==')
      tokens << ::Rdown::Tokens::LineBeginningDoubleEqual.new(
        position: position,
      )
    end

    def consume_line_beginning_triple_hyphen
      position = original_source_position
      scan('---')
      tokens << ::Rdown::Tokens::LineBeginningTripleHyphen.new(
        position: position,
      )
    end

    def consume_line_beginning_equal
      position = original_source_position
      scan('=')
      tokens << ::Rdown::Tokens::LineBeginningEqual.new(
        position: position,
      )
    end

    def consume_line_break
      position = original_source_position
      scan("\n")
      tokens << ::Rdown::Tokens::LineBreak.new(
        position: position,
      )
    end

    def consume_param
      position = original_source_position
      scan('@param')
      tokens << ::Rdown::Tokens::Param.new(
        position: position,
      )
    end

    def consume_parenthesis_left
      position = original_source_position
      scan('(')
      tokens << ::Rdown::Tokens::ParenthesisLeft.new(
        position: position,
      )
    end

    def consume_parenthesis_right
      position = original_source_position
      scan(')')
      tokens << ::Rdown::Tokens::ParenthesisRight.new(
        position: position,
      )
    end

    def consume_pipe
      position = original_source_position
      scan('|')
      tokens << ::Rdown::Tokens::Pipe.new(
        position: position,
      )
    end

    def consume_word
      position = original_source_position
      content = scan(/\S+/)
      tokens << ::Rdown::Tokens::Word.new(
        content: content,
        position: position,
      )
    end

    def match?(*args)
      scanner.match?(*args)
    end

    # @return [Rdown::Position]
    def original_source_position
      @source_map.original_source_position_of(@position)
    end

    def peek(*args)
      scanner.peek(*args)
    end

    def scan(*args)
      scanner.scan(*args).tap do |content|
        @position = begin
          if content == "\n"
            @position.go_to_next_line_head
          else
            @position.go_forward(content.length)
          end
        end
      end
    end

    # @return [String, nil]
    def scan_version
      scan(/\d+\.\d+\.\d+/)
    end

    # @return [StringScanner]
    def scanner
      @scanner ||= ::StringScanner.new(@source)
    end

    def skip_spaces
      scan(/ +/)
    end

    def tokenize_method_parameter
      consume_param
      skip_spaces
      consume_identifier
    end

    def tokenize_method_signature
      until peek(1) == "\n"
        case
        when at_beginning_of_line? && peek(3) == '---'
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
