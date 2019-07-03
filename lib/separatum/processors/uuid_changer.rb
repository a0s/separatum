require 'securerandom'

module Separatum
  module Processors
    class UuidChanger
      def initialize(**params)
        @skip_classes = (params[:skip_classes] || []).map(&:to_s)
        @skip_classes_uuid = Set[]
        @uuid_map = {}
      end

      def call(*hashes)
        hashes.flatten!
        hashes.each(&method(:collect_skip_uuid))
        hashes.map(&method(:transform))
      end

      def collect_skip_uuid(hash)
        return unless hash.key?(:id)
        return unless hash[:id].to_s.is_uuid?
        return unless hash.key?(:_klass)
        return unless @skip_classes.include?(hash[:_klass])
        @skip_classes_uuid.add(hash[:id])
      end

      def transform(hash)
        new_h = {}
        hash.each do |k, v|
          if v.is_a?(String) && v.is_uuid? && !@skip_classes_uuid.include?(v)
            unless @uuid_map[v]
              @uuid_map[v] = SecureRandom.uuid
            end
            new_h[k] = @uuid_map[v]
          else
            new_h[k] = v
          end
        end
        new_h
      end
    end
  end
end
