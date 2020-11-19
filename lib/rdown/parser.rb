# frozen_string_literal: true

module Rdown
  class Parser
    class << self
      # @param [Array<Hash>] tokens
      # @return [Hash]
      def call(tokens)
        new(tokens).call
      end
    end

    # @param [Array<Hash>] tokens
    def initialize(tokens)
      @tokens = tokens
    end

    def call
      parse_class
    end

    private

    # @param [Symbol] type
    # @return [Boolean]
    def at?(type)
      !@tokens.empty? && @tokens.first[:type] == type
    end

    # @param [Symbol] type
    # @return [Hash]
    def consume(type)
      expect(type)
      @tokens.shift
    end

    # @param [Symbol] type
    def consume_optional(type)
      consume(type) if at?(type)
    end

    # @param [Symbol] type
    # @raise [Rdown::Errors::UnexpectedEndOfTokensError]
    # @raise [Rdown::Errors::UnexpectedTokenTypeError]
    def expect(type)
      token = @tokens.first
      case
      when !token
        raise ::Rdown::Errors::UnexpectedEndOfTokensError.new(
          expected_type: type,
        )
      when token[:type] != type
        raise ::Rdown::Errors::UnexpectedTokenTypeError.new(
          actual_type: token[:type],
          expected_type: type,
        )
      end
    end

    def parse_class
      heading = parse_class_line
      description = []
      until @tokens.empty?
        case
        when at?(:code)
          description << parse_code_block
        when at?(:word)
          description << parse_paragraph
        else
          consume(:line_break)
        end
      end
      ::Rdown::Nodes::Class.new(
        description: description,
        heading: heading,
      )
    end

    # @return [Hash]
    def parse_class_line
      consume(:line_beginning_equal)
      consume(:class)
      name = consume(:word)[:content]
      if at?(:less_than)
        consume(:less_than)
        parent_name = consume(:word)[:content]
      end
      consume(:line_break)
      ::Rdown::Nodes::ClassHeading.new(
        name: name,
        parent_name: parent_name,
      )
    end

    # @return [Hash]
    def parse_code_block
      lines = []
      while at?(:code)
        lines << consume(:code)[:content]
        consume(:line_break)
      end
      ::Rdown::Nodes::CodeBlock.new(
        content: lines.join("\n"),
      )
    end

    # @return [Hash]
    def parse_paragraph
      content = parse_words
      consume(:line_break)
      while at?(:word)
        content += " #{parse_words}"
        consume(:line_break)
      end
      ::Rdown::Nodes::Paragraph.new(
        content: content,
      )
    end

    # @return [String]
    def parse_words
      words = []
      words << consume(:word)[:content] while at?(:word)
      words.join(' ')
    end
  end
end
