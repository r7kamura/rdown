# frozen_string_literal: true

module Rdown
  module Nodes
    autoload :Base, 'rdown/nodes/base'
    autoload :Class, 'rdown/nodes/class'
    autoload :ClassHeading, 'rdown/nodes/class_heading'
    autoload :CodeBlock, 'rdown/nodes/code_block'
    autoload :HeadingLevel2, 'rdown/nodes/heading_level2'
    autoload :Method, 'rdown/nodes/method'
    autoload :MethodParameter, 'rdown/nodes/method_parameter'
    autoload :MethodSignature, 'rdown/nodes/method_signature'
    autoload :Paragraph, 'rdown/nodes/paragraph'
  end
end
