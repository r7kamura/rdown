# frozen_string_literal: true

module Rdown
  module Nodes
    class Class < ::Rdown::Nodes::Base
      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :class_methods

      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :description

      # @return [Rdown::Nodes::ClassHeading]
      attr_reader :heading

      # @param [Array<Rdown::Nodes::Base>] class_methods
      # @param [Array<Rdown::Nodes::Base>] description
      # @param [Rdown::Nodes::ClassHeading] heading
      def initialize(
        class_methods:,
        description:,
        heading:
      )
        super()
        @class_methods = class_methods
        @description = description
        @heading = heading
      end
    end
  end
end
