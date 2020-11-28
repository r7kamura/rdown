# frozen_string_literal: true

module Rdown
  module Nodes
    class MethodSignature < ::Rdown::Nodes::Base
      # @return [String]
      attr_reader :name

      # @param [String] name
      def initialize(
        name:,
        **args
      )
        super(**args)
        @name = name
      end
    end
  end
end
