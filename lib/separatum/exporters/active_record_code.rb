module Separatum
  module Exporters
    class ActiveRecordCode
      attr_reader :transactions_str, :objects_str, :attributes_str, :key_str, :value_str, :ignore_not_unique_classes

      T_TRANSACTION = File.expand_path(File.join(__FILE__, %w(.. active_record_code transaction.rb.erb)))
      T_OBJECT = File.expand_path(File.join(__FILE__, %w(.. active_record_code object.rb.erb)))
      T_ATTRIBUTE = File.expand_path(File.join(__FILE__, %w(.. active_record_code attribute.rb.erb)))
      T_PROGRAM = File.expand_path(File.join(__FILE__, %w(.. active_record_code program.rb.erb)))

      def initialize(**params)
        @file_name = params[:file_name]
        @ignore_not_unique_classes = params[:ignore_not_unique_classes] || []
      end

      def call(*hashes)
        objects = ::Separatum::Converters::Hash2Object.new.(hashes.flatten)
        @objects_str = objects.map do |object|
          @attributes_str = object.attributes.map do |key, value|
            @key_str = key
            @value_str = value_to_code(value)
            ERB.new(File.read(T_ATTRIBUTE)).result(binding).strip
          end
          ERB.new(File.read(T_OBJECT)).result(binding).strip
        end
        @transactions_str = [ERB.new(File.read(T_TRANSACTION)).result(binding).strip]
        script = ERB.new(File.read(T_PROGRAM)).result(binding).strip

        if @file_name
          File.write(@file_name, script)
        end

        script
      end

      def value_to_code(value)
        if defined?(ActiveSupport::TimeWithZone) && value.is_a?(ActiveSupport::TimeWithZone)
          value.to_s.dump
        elsif defined?(Date) && value.is_a?(Date)
          value.to_s.dump
        elsif value.is_a?(String)
          value.dump
        else
          value.inspect
        end
      end
    end
  end
end
