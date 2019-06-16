module Separatum
  module Exporters
    class ActiveRecordCode
      T_TRANSACTION = File.expand_path(File.join(__FILE__, %w(.. active_record_code transaction.rb.erb)))
      T_OBJECT = File.expand_path(File.join(__FILE__, %w(.. active_record_code object.rb.erb)))
      T_ATTRIBUTE = File.expand_path(File.join(__FILE__, %w(.. active_record_code attribute.rb.erb)))

      attr_reader :objects_str, :attributes_str, :key_str, :value_str

      def call(*objects)
        @objects_str = objects.map do |object|
          @attributes_str = object.attributes.map do |key, value|
            @key_str = key
            if value.is_a?(ActiveSupport::TimeWithZone)
              @value_str = "\"#{value}\""
            else
              @value_str = value.inspect
            end
            ERB.new(File.read(T_ATTRIBUTE)).result(binding).strip
          end
          ERB.new(File.read(T_OBJECT)).result(binding).strip
        end
        ERB.new(File.read(T_TRANSACTION)).result(binding).strip
      end
    end
  end
end
