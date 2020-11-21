# frozen_string_literal: true

module Rdown
  module Tokens
    class Until < ::Rdown::Tokens::Base
      # @return [String]
      attr_reader :version

      # @param [String] version
      def initialize(
        version:,
        **args
      )
        super(**args)
        @version = version
      end
    end
  end
end
