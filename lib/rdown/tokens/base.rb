# frozen_string_literal: true

module Rdown
  module Tokens
    class Base
      include ::Rdown::Serializable

      # @return [Rdown::Position]
      attr_reader :position

      # @param [Rdown::Position] position
      def initialize(position:)
        @position = position
      end
    end
  end
end
