# frozen_string_literal: true

module Rdown
  module Nodes
    class ClassHeading < ::Rdown::Nodes::Base
      # @return [String]
      attr_reader :name

      # @return [String, nil]
      attr_reader :parent_name

      # @param [String] name
      # @param [String, nil] parent_name
      def initialize(
        name:,
        parent_name:
      )
        super()
        @name = name
        @parent_name = parent_name
      end
    end
  end
end
