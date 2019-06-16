require "separatum/version"

Dir[File.expand_path(File.join(__FILE__, %w(.. ** *.rb)))].each(&method(:require))

module Separatum
  def self.build(&block)
    instance = Class.new.include(StackMethods).new
    stack = instance.instance_eval(&block)
    Stack.new(stack: stack)
  end

  module StackMethods
    def use(klass, *params)
      fail unless klass.is_a?(Class)
      (@stack ||= []) << [klass, *params]
    end
  end

  class Stack
    def initialize(stack:)
      @stack = stack
    end

    def call(*options)
      current_options = options
      current_result = nil
      @stack.each do |el|
        klass, *params = el
        instance = klass.new(*params)
        current_result = instance.(*(current_result || current_options))
      end
      current_result
    end
  end
end
