module Remote
  module Provider
    def provider
      self.class.const_get("PROVIDER")
    end
  end
end
