module Separatum
  module Exporters
    class ActiveRecord
      def call(*hashes)
        objects = ::Separatum::Converters::Hash2Object.new.(hashes.flatten)
        ::ActiveRecord::Base.transaction do
          objects.each do |o|
            o.class.connection.execute("ALTER TABLE %s DISABLE TRIGGER ALL;" % [o.class.table_name])
            o.save!(validate: false)
            o.class.connection.execute("ALTER TABLE %s ENABLE TRIGGER ALL;" % [o.class.table_name])
          end
        end
        objects.map(&:reload)
      end
    end
  end
end
