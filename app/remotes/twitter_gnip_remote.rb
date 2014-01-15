class TwitterGnipRemote
  include Remotus::Remote
  include Remotus::RemoteGnip

  def initialize
    @search = Remotus::RemoteGnip.search_client
    @rules = Remotus::RemoteGnip.rules_client
    @stream = Remotus::RemoteGnip.stream_client
  end

  def build_rules
    @accounts = Account.all
    @account.each do |account| 
      account.geolocations.each do |geolocation|
        @account.searches.each do |search|
          
        end
      end
    end
  end
end
