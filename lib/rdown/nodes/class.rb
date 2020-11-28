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

      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :instance_methods

      # @param [Array<Rdown::Nodes::Base>] class_methods
      # @param [Array<Rdown::Nodes::Base>] description
      # @param [Rdown::Nodes::ClassHeading] heading
      # @param [Array<Rdown::Nodes::Base>] instance_methods
      def initialize(
        class_methods:,
        description:,
        heading:,
        instance_methods:,
        **args
      )
        super(**args)
        @class_methods = class_methods
        @description = description
        @heading = heading
        @instance_methods = instance_methods
      end
    end
  end
end
