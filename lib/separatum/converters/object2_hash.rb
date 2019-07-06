module Separatum
  module Converters
    class Object2Hash
      def initialize(**params)
        @common_fields = params[:common_fields] || {}
      end

      def call(*objects, **params)
        objects.flatten.map do |object|
          hash =
            if object.respond_to?(:as_json)
              object.as_json
            elsif object.respond_to?(:to_hash)
              object.to_hash
            elsif object.respond_to?(:to_h)
              object.to_h
            else
              fail
            end
          klass = object.class.respond_to?(:name) ? object.class.name : object.class.to_s
          hash.symbolize_keys.merge(_klass: klass).merge(@common_fields)
        end
      end
    end
  end
end
