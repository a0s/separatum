module Separatum
  module Converters
    class Object2Hash
      def call(*objects)
        objects.map do |object|
          klass = object.class.respond_to?(:name) ? object.class.name : object.class.to_s
          if object.respond_to?(:as_json)
            { _klass: klass }.merge(object.as_json)
          elsif object.respond_to?(:to_hash)
            { _klass: klass }.merge(object.to_hash)
          elsif object.respond_to?(:to_h)
            { _klass: klass }.merge(object.to_h)
          else
            fail(object.inspect)
          end
        end
      end
    end
  end
end
