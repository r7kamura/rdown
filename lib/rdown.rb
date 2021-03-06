# frozen_string_literal: true

require 'rdown/version'

module Rdown
  autoload :Errors, 'rdown/errors'
  autoload :Nodes, 'rdown/nodes'
  autoload :Parser, 'rdown/parser'
  autoload :Position, 'rdown/position'
  autoload :PositionDelta, 'rdown/position_delta'
  autoload :PreProcessor, 'rdown/pre_processor'
  autoload :Serializable, 'rdown/serializable'
  autoload :SourceMap, 'rdown/source_map'
  autoload :Tokenizer, 'rdown/tokenizer'
  autoload :Tokens, 'rdown/tokens'

  class << self
    # @param [String]
    # @return [Rdown::Nodes::Base]
    def parse(source)
      pre_processed_source = ::Rdown::PreProcessor.call(source)
      tokens = ::Rdown::Tokenizer.call(**pre_processed_source)
      ::Rdown::Parser.call(tokens)
    end
  end
end
