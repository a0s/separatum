module Separatum
  module Processors
    class Inspect
      def call(*array)
        array.each { |o| puts "#{o.inspect}" }
        array
      end
    end
  end
end
