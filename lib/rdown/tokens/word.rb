# frozen_string_literal: true

module Rdown
  module Tokens
    class Word < ::Rdown::Tokens::Base
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
