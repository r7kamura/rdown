# frozen_string_literal: true

module Rdown
  module Tokens
    class Identifier < ::Rdown::Tokens::Base
      # @return [String]
      attr_reader :content

      # @param [String] content
      def initialize(
        content:,
        **args
      )
        super(**args)
        @content = content
      end
    end
  end
end
