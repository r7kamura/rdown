# frozen_string_literal: true

module Rdown
  module Errors
    class UnexpectedEndOfTokens < ::StandardError
    end

    class UnexpectedTokenTypeError < ::StandardError
      # @param [Symbol] actual_type
      # @param [Symbol] expected_type
      def initialize(actual_type:, expected_type:)
        @actual_type = actual_type
        @expected_type = expected_type
        super("Expected #{@expected_type} type token, but got #{@actual_type} type token.")
      end
    end
  end
end
