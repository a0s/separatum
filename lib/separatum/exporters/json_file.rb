module Separatum
  module Exporters
    class JsonFile
      def initialize(file_name:, pretty_print: false)
        @file_name = file_name
        @pretty_print = pretty_print
      end

      def call(*array)
        str = @pretty_print ? JSON.pretty_generate(array) : JSON.dump(array)
        File.write(@file_name, str)
        array
      end
    end
  end
end
