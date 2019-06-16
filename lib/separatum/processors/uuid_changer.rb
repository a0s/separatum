require 'securerandom'

module Separatum
  module Processors
    class UuidChanger
      def initialize
        @uuid_map = {}
      end

      def call(*hashes)
        hashes.map(&method(:transform_hash))
      end

      def transform_hash(h)
        new_h = {}
        h.each do |k, v|
          if v.is_a?(String) && v.is_uuid?
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
