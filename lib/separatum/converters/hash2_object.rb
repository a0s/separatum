module Separatum
  module Converters
    class Hash2Object
      def call(*hashes)
        hashes.flatten.map do |hash|
          hash_copy = hash.symbolize_keys
          klass = Object.const_get(hash_copy.delete(:_klass))
          hash_copy.keys.map(&:to_s).select { |k| '_' == k[0] }.each { |k| hash_copy.delete(k.to_sym) }
          object = klass.new
          hash_copy.each do |k, v|
            object.send("#{k}=", v)
          end
          object
        end
      end
    end
  end
end
