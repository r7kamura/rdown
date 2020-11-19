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

    # @param [Hash] node1
    # @param [Hash] node2
    # @return [Hash]
    def merge_description_nodes(node1, node2)
      node1[:content] = [
        node1[:content],
        node2[:content],
      ].join(' ')
      node1
    end

    def parse_class
      node = parse_class_line
      previous_line_is_description_line = false
      until @tokens.empty?
        if at?(:line_break)
          parse_empty_line
          previous_line_is_description_line = false
        else
          node[:descriptions] << begin
            if previous_line_is_description_line
              merge_description_nodes(node[:descriptions].pop, parse_description_line)
            else
              parse_description_line
            end
          end
          previous_line_is_description_line = true
        end
      end
      node
    end

    # @return [Hash]
    def parse_class_line
      consume(:line_beginning_equal)
      skip_spaces
      consume(:class)
      skip_spaces
      class_word_token = consume(:word)
      skip_spaces
      if at?(:less_than)
        consume(:less_than)
        skip_spaces
        parent_word_token = consume(:word)
      end
      consume(:line_break)
      {
        descriptions: [],
        name: class_word_token[:content],
        parent_name: parent_word_token ? parent_word_token[:content] : nil,
        type: :class,
      }
    end

    # @return [Hash]
    def parse_description_line
      description = +''
      until at?(:line_break)
        if at?(:word)
          description << consume(:word)[:content]
        else
          consume(:spaces)
          description << ' '
        end
      end
      consume(:line_break)
      {
        content: description,
        type: :description,
      }
    end

    def parse_empty_line
      consume(:line_break)
    end

    def skip_spaces
      consume_optional(:spaces)
    end
  end
end
