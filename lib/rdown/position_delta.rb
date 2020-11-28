# frozen_string_literal: true

module Rdown
  class PositionDelta
    # @return [Integer]
    attr_reader :column

    # @return [Integer]
    attr_reader :line

    # @param [Integer] column
    # @param [Integer] line
    def initialize(
      column: 0,
      line: 0
    )
      @column = column
      @line = line
    end

    def -@
      self.class.new(
        column: -@column,
        line: -@line,
      )
    end
  end
end
