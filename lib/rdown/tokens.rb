# frozen_string_literal: true

module Rdown
  module Tokens
    autoload :ArrowRight, 'rdown/tokens/arrow_right'
    autoload :Asterisk, 'rdown/tokens/asterisk'
    autoload :Base, 'rdown/tokens/base'
    autoload :BracketLeft, 'rdown/tokens/bracket_left'
    autoload :BracketRight, 'rdown/tokens/bracket_right'
    autoload :Class, 'rdown/tokens/class'
    autoload :ClassMethods, 'rdown/tokens/class_methods'
    autoload :Code, 'rdown/tokens/code'
    autoload :Identifier, 'rdown/tokens/identifier'
    autoload :Keyword, 'rdown/tokens/keyword'
    autoload :LessThan, 'rdown/tokens/less_than'
    autoload :LineBeginningEqual, 'rdown/tokens/line_beginning_equal'
    autoload :LineBeginningDoubleEqual, 'rdown/tokens/line_beginning_double_equal'
    autoload :LineBeginningTripleHyphen, 'rdown/tokens/line_beginning_triple_hyphen'
    autoload :LineBreak, 'rdown/tokens/line_break'
    autoload :ParenthesisLeft, 'rdown/tokens/parenthesis_left'
    autoload :ParenthesisRight, 'rdown/tokens/parenthesis_right'
    autoload :Pipe, 'rdown/tokens/pipe'
    autoload :Word, 'rdown/tokens/word'
  end
end
