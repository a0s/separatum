module Separatum
  module Exporters
    class JsonFile
      def initialize(file_name:, pretty_print: false)
        @file_name = file_name
        @pretty_print = pretty_print
      end

      def call(*hashes)
        hashes.flatten!
        str = @pretty_print ? JSON.pretty_generate(hashes) : JSON.dump(hashes)
        File.write(@file_name, str)
        hashes
      end
    end
  end
end
