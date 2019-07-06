require 'time'

module Separatum
  module Processors
    class TimeMachine
      def call(*hashes)
        time_current = Time.now
        hashes.flatten.map do |hash|
          if hash.key?(:_time_machine)
            time_offset = time_current - Time.parse(hash[:_time_machine])
            new_hash = {}
            hash.each do |k, v|
              if k == :_time_machine
                next
              elsif (time = (Time.parse(v) rescue nil))
                new_hash[k] = (time + time_offset).to_s
              else
                new_hash[k] = v
              end
            end
            new_hash
          else
            hash
          end
        end
      end
    end
  end
end
