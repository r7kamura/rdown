# frozen_string_literal: true

module Rdown
  module Tokens
    class MethodSignature < ::Rdown::Tokens::Base
      # @return [String]
      attr_reader :method_name

      # @return [String]
      attr_reader :payload

      # @param [String] method_name
      # @param [String] payload
      def initialize(
        method_name:,
        payload:,
        **args
      )
        super(**args)
        @method_name = method_name
        @payload = payload
      end
    end
  end
end
