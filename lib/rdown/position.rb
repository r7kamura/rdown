# frozen_string_literal: true

module Rdown
  class Position
    # @return [Integer]
    attr_accessor :column

    # @return [Integer]
    attr_accessor :line

    def initialize
      @column = 1
      @line = 1
    end

    def go_to_next_line
      @line += 1
    end

    def hash
      to_hash.hash
    end

    def to_hash
      {
        column: @column,
        line: @line,
      }
    end
  end
end
