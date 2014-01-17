module Remotus
  module RemoteGnip
    def self.rules_client
      Gnip::RulesClient.new(uri: ENV["GNIP_RULES_URI"],
                            username: ENV["GNIP_USERNAME"],
                            password: ENV["GNIP_PASSWORD"])
    end

    def self.stream_client
      Gnip::StreamClient.new(uri: ENV["GNIP_STREAM_URI"],
                             username: ENV["GNIP_USERNAME"],
                             password: ENV["GNIP_PASSWORD"])
    end

    def self.search_client
      Gnip::SearchClient.new(uri: ENV["GNIP_SEARCH_URI"],
                             username: ENV["GNIP_USERNAME"],
                             password: ENV["GNIP_PASSWORD"])
    end
  end
end
