# frozen_string_literal: true

module Rdown
  class Parser
    class << self
      # @param [Array<Hash>] tokens
      # @return [Rdown::Nodes::Class]
      def call(tokens)
        new(tokens).call
      end
    end

    # @param [Array<Hash>] tokens
    def initialize(tokens)
      @tokens = tokens
    end

    # @return [Rdown::Nodes::Class]
    def call
      parse_class
    end

    private

    # @param [String] type
    # @return [Boolean]
    def at?(type)
      !@tokens.empty? && @tokens.first.type == type
    end

    # @param [String] type
    # @return [Rdown::Tokens::Base]
    def consume(type)
      expect(type)
      @tokens.shift
    end

    # @param [String] type
    # @raise [Rdown::Errors::UnexpectedEndOfTokensError]
    # @raise [Rdown::Errors::UnexpectedTokenTypeError]
    def expect(type)
      token = @tokens.first
      case
      when !token
        raise ::Rdown::Errors::UnexpectedEndOfTokensError.new(
          expected_type: type,
        )
      when token.type != type
        raise ::Rdown::Errors::UnexpectedTokenTypeError.new(
          actual_type: token.type,
          expected_type: type,
        )
      end
    end

    def parse_class
      heading = parse_class_heading
      description = parse_description
      ::Rdown::Nodes::Class.new(
        description: description,
        heading: heading,
      )
    end

    # @return [Array<Rdown::Nodes::Base>]
    def parse_description
      description = []
      until @tokens.empty?
        case
        when at?('Code')
          description << parse_code_block
        when at?('Word')
          description << parse_paragraph
        else
          consume('LineBreak')
        end
      end
      description
    end

    # @return [Rdown::Nodes::ClassHeading]
    def parse_class_heading
      consume('LineBeginningEqual')
      consume('Class')
      name = consume('Word').content
      if at?('LessThan')
        consume('LessThan')
        parent_name = consume('Word').content
      end
      consume('LineBreak')
      ::Rdown::Nodes::ClassHeading.new(
        name: name,
        parent_name: parent_name,
      )
    end

    # @return [Rdown::Nodes::CodeBlock]
    def parse_code_block
      lines = []
      while at?('Code')
        lines << consume('Code').content
        consume('LineBreak')
      end
      ::Rdown::Nodes::CodeBlock.new(
        content: lines.join("\n"),
      )
    end

    # @return [Rdown::Nodes::Paragraph]
    def parse_paragraph
      sections = []
      while at?('Word')
        sections << parse_words
        consume('LineBreak')
      end
      ::Rdown::Nodes::Paragraph.new(
        content: sections.join(' '),
      )
    end

    # @return [String]
    def parse_words
      words = []
      words << consume('Word').content while at?('Word')
      words.join(' ')
    end
  end
end
