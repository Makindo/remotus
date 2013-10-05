module Remotus
  class Denormalizer
    private

    def attributes
      AltStruct.new(sliced_data)
    end

    def sliced_data
      @data.with_indifferent_access.slice(*keys)
    end

    def keys
      self.class.const_get("KEYS")
    end
  end
end
