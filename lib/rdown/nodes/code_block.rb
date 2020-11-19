# frozen_string_literal: true

module Rdown
  module Nodes
    class CodeBlock < ::Rdown::Nodes::Base
      # @return [String]
      attr_reader :content

      # @param [String] content
      def initialize(
        content:
      )
        super()
        @content = content
      end
    end
  end
end