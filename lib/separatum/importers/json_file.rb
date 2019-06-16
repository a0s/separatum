module Separatum
  module Importers
    class JsonFile
      def initialize(file_name:)
        @file_name = file_name
      end

      def call(*_)
        str = File.read(@file_name)
        JSON.parse(str)
      end
    end
  end
end
