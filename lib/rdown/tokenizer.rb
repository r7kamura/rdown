# frozen_string_literal: true

module Rdown
  class Tokenizer
    class << self
      # @param [String] source
      # @return [Hash]
      def call(source)
        new(source).call
      end
    end

    # @param [String] source
    def initialize(source)
      @source = source
    end

    # @return [Hash]
    def call
      {}
    end
  end
end
