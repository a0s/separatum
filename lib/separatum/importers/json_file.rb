module Separatum
  module Importers
    class JsonFile
      def initialize(file_name:)
        @file_name = file_name
      end

      def call(*)
        str = File.read(@file_name)
        hash = JSON.parse(str)
        hash.symbolize_keys
      end
    end
  end
end
