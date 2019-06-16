module Separatum
  module Converters
    class Hash2Object
      def call(*hashes)
        hashes.map do |hash|
          hash_copy = hash.symbolize_keys
          _klass = hash_copy.delete(:_klass).constantize
          instance = _klass.new
          hash_copy.symbolize_keys.each do |k, v|
            instance.send("#{k}=", v)
          end
          instance
        end
      end
    end
  end
end
