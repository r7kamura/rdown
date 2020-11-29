# frozen_string_literal: true

module Rdown
  module Nodes
    class MethodException < ::Rdown::Nodes::Base
      # @return [String]
      attr_reader :description

      # @return [String]
      attr_reader :name

      # @param [Array<Rdown::Nodes::Base>] description
      # @param [Array<Rdown::Nodes::Base>] signature
      # @param [String] description
      # @param [String] name
      def initialize(
        description:,
        name:,
        **args
      )
        super(**args)
        @description = description
        @name = name
      end
    end
  end
end
