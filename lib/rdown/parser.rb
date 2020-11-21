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
      !at_end_of_tokens? && @tokens.first.type == type
    end

    # @return [Boolean]
    def at_end_of_tokens?
      @tokens.empty?
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
      class_methods = parse_class_methods
      instance_methods = parse_instance_methods
      ::Rdown::Nodes::Class.new(
        class_methods: class_methods,
        description: description,
        heading: heading,
        instance_methods: instance_methods,
      )
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

    # @return [Array<Rdown::Nodes::Base>]
    def parse_class_methods
      if at?('LineBeginningDoubleEqual') && @tokens[1].type == 'ClassMethods'
        parse_class_methods_heading
        skip_line_breaks
        parse_methods
      else
        []
      end
    end

    def parse_class_methods_heading
      consume('LineBeginningDoubleEqual')
      consume('ClassMethods')
      consume('LineBreak')
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

    # @return [Array<Rdown::Nodes::Base>]
    def parse_description
      description = []
      loop do
        case
        when at?('Code')
          description << parse_code_block
        when at?('Word')
          description << parse_paragraph
        when at?('LineBreak')
          consume('LineBreak')
        else
          break
        end
      end
      description
    end

    # @return [Array<Rdown::Nodes::Base>]
    def parse_instance_methods
      if at?('LineBeginningDoubleEqual') && @tokens[1].type == 'InstanceMethods'
        parse_instance_methods_heading
        skip_line_breaks
        parse_methods
      else
        []
      end
    end

    def parse_instance_methods_heading
      consume('LineBeginningDoubleEqual')
      consume('InstanceMethods')
      consume('LineBreak')
    end

    # @return [Rdown::Nodes::Method]
    def parse_method
      method_signatures = parse_method_signatures
      description = parse_description
      ::Rdown::Nodes::Method.new(
        description: description,
        signatures: method_signatures,
      )
    end

    # @return [String]
    def parse_method_name
      method_name = +''
      loop do
        case
        when at?('Identifier')
          method_name += consume('Identifier').content
        when at?('BracketLeft')
          skip
          method_name += '['
        when at?('BracketRight')
          skip
          method_name += ']'
        else
          break
        end
      end
      method_name
    end

    # @return [Rdown::Nodes::MethodSignature]
    def parse_method_signature
      consume('LineBeginningTripleHyphen')
      name = parse_method_name
      skip until at?('LineBreak')
      consume('LineBreak')
      ::Rdown::Nodes::MethodSignature.new(
        name: name,
      )
    end

    def parse_method_signatures
      method_signatures = []
      method_signatures << parse_method_signature
      method_signatures << parse_method_signature while at?('LineBeginningTripleHyphen')
      method_signatures
    end

    # @return [Array<Rdown::Nodes::Base>]
    def parse_methods
      methods = []
      methods << parse_method while at?('LineBeginningTripleHyphen')
      methods
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

    def skip
      @tokens.shift
    end

    def skip_line_breaks
      skip while at?('LineBreak')
    end
  end
end
