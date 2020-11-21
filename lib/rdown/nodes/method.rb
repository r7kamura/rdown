# frozen_string_literal: true

module Rdown
  module Nodes
    class Method < ::Rdown::Nodes::Base
      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :description

      # @return [Array<Rdown::Nodes::MethodException>]
      attr_reader :exceptions

      # @return [Array<Rdown::Nodes::MethodParameter>]
      attr_reader :parameters

      # @return [Array<Rdown::Nodes::MethodSignature>]
      attr_reader :signatures

      # @return [String, nil]
      attr_reader :version_since

      # @return [String, nil]
      attr_reader :version_until

      # @param [Array<Rdown::Nodes::Base>] description
      # @param [Array<Rdown::Nodes::MethodException>] exceptions
      # @param [Array<Rdown::Nodes::MethodParameter>] parameters
      # @param [Array<Rdown::Nodes::Base>] signature
      # @param [String, nil] version_since
      # @param [String, nil] version_until
      def initialize(
        description:,
        exceptions:,
        parameters:,
        signatures:,
        version_since:,
        version_until:
      )
        super()
        @description = description
        @exceptions = exceptions
        @parameters = parameters
        @signatures = signatures
        @version_since = version_since
        @version_until = version_until
      end
    end
  end
end
