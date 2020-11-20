# frozen_string_literal: true

module Rdown
  module Nodes
    class Method < ::Rdown::Nodes::Base
      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :description

      # @return [String]
      attr_reader :name

      # @param [String] name
      def initialize(
        description:,
        name:
      )
        super()
        @description = description
        @name = name
      end
    end
  end
end
