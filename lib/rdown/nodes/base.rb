# frozen_string_literal: true

module Rdown
  module Nodes
    class Base
      # @return [Array<Symbol>]
      def attribute_names
        instance_variable_names.map do |instance_variable_name|
          instance_variable_name.to_s[1..-1].to_sym
        end + %i[type]
      end

      # @return [Hash]
      def to_hash
        attribute_names.each_with_object({}) do |instance_variable_name, hash|
          hash[instance_variable_name] = __send__(instance_variable_name)
        end
      end

      # @return [String]
      def type
        self.class.name.split('::').last
      end
    end
  end
end
