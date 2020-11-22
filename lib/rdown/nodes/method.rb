# frozen_string_literal: true

module Rdown
  module Nodes
    class Method < ::Rdown::Nodes::Base
      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :description

      # @return [Array<Rdown::Nodes::MethodParameter>]
      attr_reader :parameters

      # @return [Array<Rdown::Nodes::MethodSignature>]
      attr_reader :signatures

      # @param [Array<Rdown::Nodes::Base>] description
      # @param [Array<Rdown::Nodes::MethodParameter>] parameters
      # @param [Array<Rdown::Nodes::Base>] signature
      # @param [String, nil] version_since
      # @param [String, nil] version_until
      def initialize(
        description:,
        parameters:,
        signatures:
      )
        super()
        @description = description
        @parameters = parameters
        @signatures = signatures
      end
    end
  end
end
