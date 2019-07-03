module Separatum
  module Processors
    class FieldChanger
      # Allows:
      #   SomeClass#method
      #   SomeNamespace::SomeClass#method
      #   SuperNamespace::SomeNamespace::SomeClass#method
      CLASS_METHOD = /^([A-Za-z_][0-9A-Za-z_]*(?:::[A-Za-z_][0-9A-Za-z_]*)*)#([A-Za-z_][0-9A-Za-z_]*)$/

      def initialize(*options, &block)
        parse_options(*options, &block)
      end

      def call(*hashes)
        hashes.flatten.map do |hash|
          new_hash = hash.symbolize_keys
          if hash[:_klass] == @klass && hash.key?(@method)
            new_hash[@method] = @transformer.call(hash[@method])
          end
          new_hash
        end
      end

      def parse_options(*options)
        p1 = options.shift
        if p1.is_a?(String) && (res = p1.match(CLASS_METHOD))
          @klass = res[1]
          @method = res[2].to_sym
        elsif p1.is_a?(Class)
          @klass = p1.to_s
          p2 = options.shift
          if p2.is_a?(Symbol)
            @method = p2
          else
            fail
          end
        else
          fail
        end

        if block_given?
          @transformer = Proc.new
          pp @transformer
        else
          p3 = options.shift
          if p3.is_a?(Proc)
            @transformer = p3
          elsif p3.is_a?(String) && (res = p3.match(CLASS_METHOD))
            @transformer = Proc.new { |value| Object.const_get(res[1]).new.send(res[2].to_sym, value) }
          elsif p3.is_a?(Class)
            p4 = options.shift
            if p4.is_a?(Symbol)
              @transformer = Proc.new { |value| p3.new.send(p4, value) }
            else
              fail
            end
          else
            fail
          end
        end
      end
    end
  end
end
