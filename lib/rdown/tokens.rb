# frozen_string_literal: true

module Rdown
  module Tokens
    autoload :Base, 'rdown/tokens/base'
    autoload :Class, 'rdown/tokens/class'
    autoload :ClassMethods, 'rdown/tokens/class_methods'
    autoload :Code, 'rdown/tokens/code'
    autoload :Identifier, 'rdown/tokens/identifier'
    autoload :InstanceMethods, 'rdown/tokens/instance_methods'
    autoload :LessThan, 'rdown/tokens/less_than'
    autoload :LineBeginningEqual, 'rdown/tokens/line_beginning_equal'
    autoload :LineBeginningDoubleEqual, 'rdown/tokens/line_beginning_double_equal'
    autoload :LineBeginningTripleHyphen, 'rdown/tokens/line_beginning_triple_hyphen'
    autoload :LineBreak, 'rdown/tokens/line_break'
    autoload :MethodSignature, 'rdown/tokens/method_signature'
    autoload :Param, 'rdown/tokens/param'
    autoload :Raise, 'rdown/tokens/raise'
    autoload :Word, 'rdown/tokens/word'
  end
end
