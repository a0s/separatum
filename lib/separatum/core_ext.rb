unless Hash.new.respond_to?(:symbolize_keys)
  class Hash
    def symbolize_keys
      Hash[self.map { |(k, v)| [k.to_sym, v] }]
    end
  end
end

unless String.new.respond_to?(:is_uuid?)
  class String
    def is_uuid?
      !!self.match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
    end
  end
end
