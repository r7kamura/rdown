# frozen_string_literal: true

require 'strscan'

module Rdown
  class Tokenizer
    class << self
      # @param [String] source
      # @return [Array<Hash>]
      def call(source)
        new(source).call
      end
    end

    # @param [String] source
    def initialize(source)
      @source = source
    end

    # @return [Array<Hash>]
    def call
      until on_eos?
        case
        when on_beginning_of_line? && peek(1) == '='
          consume_line_beginning_equal
        when on_beginning_of_line? && peek(1) == '@'
          consume_keyword
        when peek(1) == "\n"
          consume_line_break
        when peek(1) == ' '
          consume_spaces
        when peek(1) == '<'
          consume_less_than
        when match?(/\Aclass\b/)
          consume_class
        else
          consume_word
        end
      end
      tokens
    end

    private

    def consume_class
      pointer = scanner.pointer
      scanner.pointer += 'class'.bytesize
      tokens << {
        pointer: pointer,
        type: :class,
      }
    end

    def consume_keyword
      pointer = scanner.pointer
      scanner.pointer += '@'.bytesize
      content = scanner.scan(/\w+/)
      tokens << {
        content: content,
        pointer: pointer,
        type: :keyword,
      }
    end

    def consume_less_than
      pointer = scanner.pointer
      scanner.pointer += '<'.bytesize
      tokens << {
        pointer: pointer,
        type: :less_than,
      }
    end

    def consume_line_beginning_equal
      pointer = scanner.pointer
      scanner.pointer += '='.bytesize
      tokens << {
        pointer: pointer,
        type: :line_beginning_equal,
      }
    end

    def consume_line_break
      pointer = scanner.pointer
      scanner.pointer += "\n".bytesize
      tokens << {
        pointer: pointer,
        type: :line_break,
      }
    end

    def consume_spaces
      pointer = scanner.pointer
      scanner.scan(/ +/)
      tokens << {
        pointer: pointer,
        type: :spaces,
      }
    end

    def consume_word
      pointer = scanner.pointer
      content = scanner.scan(/\S+/)
      tokens << {
        content: content,
        pointer: pointer,
        type: :word,
      }
    end

    def match?(*args)
      scanner.match?(*args)
    end

    # @return [Boolean]
    def on_beginning_of_line?
      scanner.beginning_of_line?
    end

    # @return [Boolean]
    def on_eos?
      scanner.eos?
    end

    def peek(*args)
      scanner.peek(*args)
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
