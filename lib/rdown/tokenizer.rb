# frozen_string_literal: true

require 'strscan'

module Rdown
  class Tokenizer
    class << self
      # @param [String] source
      # @return [Hash]
      def call(source)
        new(source).call
      end
    end

    SYMBOL_FOR_KEYWORD = '@'

    # @param [String] source
    def initialize(source)
      @source = source
    end

    # @return [Hash]
    def call
      until on_eos?
        case
        when on_beginning_of_line? && peek == SYMBOL_FOR_KEYWORD
          consume_keyword
        when peek == "\n"
          consume_line_break
        when peek == ' '
          consume_spaces
        else
          consume_word
        end
      end
      tokens
    end

    private

    def consume_keyword
      pointer = scanner.pointer
      scanner.pointer += SYMBOL_FOR_KEYWORD.bytesize
      content = scanner.scan(/\w+/)
      tokens << {
        content: content,
        pointer: pointer,
        type: 'keyword',
      }
    end

    def consume_line_break
      pointer = scanner.pointer
      scanner.pointer += "\n".bytesize
      tokens << {
        pointer: pointer,
        type: 'line_break',
      }
    end

    def consume_spaces
      pointer = scanner.pointer
      scanner.scan(/ +/)
      tokens << {
        pointer: pointer,
        type: 'spaces',
      }
    end

    def consume_word
      pointer = scanner.pointer
      content = scanner.scan(/\S+/)
      tokens << {
        content: content,
        pointer: pointer,
        type: 'word',
      }
    end

    # @return [Boolean]
    def on_beginning_of_line?
      scanner.beginning_of_line?
    end

    # @return [Boolean]
    def on_eos?
      scanner.eos?
    end

    # @return [String]
    def peek
      scanner.peek(1)
    end

    def scan(*args)
      scanner.scan(*args)
    end

    # @return [StringScanner]
    def scanner
      @scanner ||= ::StringScanner.new(@source)
    end

    # @return [Array<Hash>]
    def tokens
      @tokens ||= []
    end
  end
end
