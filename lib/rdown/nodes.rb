# frozen_string_literal: true

module Rdown
  module Nodes
    autoload :Base, 'rdown/nodes/base'
    autoload :Class, 'rdown/nodes/class'
    autoload :ClassHeading, 'rdown/nodes/class_heading'
    autoload :CodeBlock, 'rdown/nodes/code_block'
    autoload :HeadingLevel2, 'rdown/nodes/heading_level2'
    autoload :Method, 'rdown/nodes/method'
    autoload :Paragraph, 'rdown/nodes/paragraph'
  end
end
