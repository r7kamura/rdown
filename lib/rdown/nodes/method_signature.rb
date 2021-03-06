# frozen_string_literal: true

module Rdown
  module Nodes
    class MethodSignature < ::Rdown::Nodes::Base
      # @return [String]
      attr_reader :method_name

      # @param [String] method_name
      def initialize(
        method_name:,
        **args
      )
        super(**args)
        @method_name = method_name
      end
    end
  end
end
