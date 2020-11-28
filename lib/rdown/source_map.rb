# frozen_string_literal: true

module Rdown
  class SourceMap
    def initialize
      @hash = {}
    end

    # @param [Rdown::Position] from
    # @return [Rdown::Position, nil]
    def get(from)
      @hash[from]
    end

    # @return [Rdown::Position]
    def original_source_position_of(position)
      from = previous_generated_code_position_from(position)
      to = get(from)
      delta = position - from
      to + delta
    end

    # @param [Rdown::Position] from
    # @param [Rdown::Position] to
    def set(from, to)
      @hash[from] = to
    end

    private

    # @return [Rdown::Position]
    def previous_generated_code_position_from(position)
      @hash.keys.select do |key|
        key <= position
      end.max
    end
  end
end
