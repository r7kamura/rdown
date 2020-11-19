# frozen_string_literal: true

module Rdown
  module Tokens
    class Base
      include ::Rdown::Serializable

      # @return [Integer]
      attr_reader :pointer

      # @param [Integer] pointer
      def initialize(pointer:)
        @pointer = pointer
      end
    end
  end
end
