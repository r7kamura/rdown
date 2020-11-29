# frozen_string_literal: true

module Rdown
  module Nodes
    class Method < ::Rdown::Nodes::Base
      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :description

      # @return [Array<Rdown::Nodes::MethodParameter>]
      attr_reader :parameters

      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :post_description

      # @return [Array<Rdown::Nodes::MethodSignature>]
      attr_reader :signatures

      # @param [Array<Rdown::Nodes::Base>] description
      # @param [Array<Rdown::Nodes::MethodParameter>] parameters
      # @param [Array<Rdown::Nodes::Base>] post_description
      # @param [Array<Rdown::Nodes::Base>] signature
      # @param [String, nil] version_since
      # @param [String, nil] version_until
      def initialize(
        description:,
        parameters:,
        post_description:,
        signatures:,
        **args
      )
        super(**args)
        @description = description
        @parameters = parameters
        @post_description = post_description
        @signatures = signatures
      end
    end
  end
end
