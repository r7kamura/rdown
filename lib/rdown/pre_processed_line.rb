# frozen_string_literal: true

module Rdown
  PreProcessedLine = ::Struct.new(
    :content,
    :position,
    keyword_init: true,
  )
end
