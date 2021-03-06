# frozen_string_literal: true

module Rdown
  class PreProcessor
    class << self
      # @param [String] source
      # @return [Hash]
      def call(source)
        new(source).call
      end
    end

    # @param [String] source
    def initialize(source)
      @position = ::Rdown::Position.new
      @pre_processed_lines = []
      @source = source
      @source_map = ::Rdown::SourceMap.new
      @version_since = nil
      @version_until = nil
    end

    # @return [Hash]
    def call
      until source_lines.empty?
        case
        when source_lines.first.start_with?('#@end')
          consume_end
        when source_lines.first.start_with?('#@since')
          consume_since
        when source_lines.first.start_with?('#@until')
          consume_until
        when at_valid_version_line?
          consume_normal
        else
          shift
        end
      end
      {
        source: @pre_processed_lines.join,
        source_map: @source_map,
      }
    end

    private

    # @todo
    # @return [Boolean]
    def at_valid_version_line?
      true
    end

    def consume_end
      @version_since = nil
      @version_until = nil
      shift
    end

    def consume_normal
      @source_map.set(position_of_pre_processed_code, @position)
      @pre_processed_lines << shift
    end

    def consume_since
      @version_since = true
      shift
    end

    def consume_until
      @version_until = true
      shift
    end

    # @return [Rdown::Position]
    def position_of_pre_processed_code
      ::Rdown::Position.new(
        column: 1,
        line: @pre_processed_lines.length + 1,
      )
    end

    # @return [String]
    def shift
      @position = @position.go_to_next_line_head
      source_lines.shift
    end

    # @return [Array<String>]
    def source_lines
      @source_lines ||= @source.lines
    end
  end
end
