# frozen_string_literal: true

module Rdown
  module Nodes
    class Method < ::Rdown::Nodes::Base
      # @return [Array<Rdown::Nodes::Base>]
      attr_reader :description

      # @return [Array<Rdown::Nodes::MethodSignature>]
      attr_reader :signatures

      # @param [Array<Rdown::Nodes::Base>] description
      # @param [Array<Rdown::Nodes::Base>] signature
      def initialize(
        description:,
        signatures:
      )
        super()
        @description = description
        @signatures = signatures
      end
    end
  end
end
