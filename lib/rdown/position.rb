# frozen_string_literal: true

module Rdown
  class Position
    include ::Comparable

    # @return [Integer]
    attr_reader :column

    # @return [Integer]
    attr_reader :line

    # @param [Integer] column
    # @param [Integer] line
    def initialize(
      column: 1,
      line: 1
    )
      @column = column
      @line = line
    end

    # @param [Rdown::PositionDelta] delta
    # @return [Rdown::Position]
    def +(other)
      self.class.new(
        column: (other.line.zero? ? @column : 1) + other.column,
        line: @line + other.line,
      )
    end

    # @param [Rdown::Position, Rdown::PositionDelta] other_or_delta
    # @return [Rdown::Position, Rdown::PositionDelta]
    def -(other)
      case other
      when ::Rdown::Position
        if @line == other.line
          ::Rdown::PositionDelta.new(
            column: @column - other.column,
          )
        else
          ::Rdown::PositionDelta.new(
            column: @column - 1,
            line: @line - other.line,
          )
        end
      when ::Rdown::PositionDelta
        self + -other
      else
        raise ::ArgumentError
      end
    end

    def <=>(other)
      to_array <=> other.to_array
    end

    # @param [Integer] length
    def go_forward(length)
      self.class.new(
        column: @column + length,
        line: @line,
      )
    end

    # @return [Rdown::Position]
    def go_to_next_line_head
      self.class.new(
        column: 1,
        line: @line + 1,
      )
    end

    def eql?(other)
      to_hash == other.to_hash
    end

    def hash
      to_hash.hash
    end

    def to_array
      [@line, @column]
    end

    def to_hash
      {
        column: @column,
        line: @line,
      }
    end
  end
end
