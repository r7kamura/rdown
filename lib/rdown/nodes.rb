# frozen_string_literal: true

module Rdown
  module Nodes
    autoload :Base, 'rdown/nodes/base'
    autoload :Class, 'rdown/nodes/class'
    autoload :ClassHeading, 'rdown/nodes/class_heading'
    autoload :CodeBlock, 'rdown/nodes/code_block'
    autoload :Paragraph, 'rdown/nodes/paragraph'
  end
end
