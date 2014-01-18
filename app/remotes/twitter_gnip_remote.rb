class TwitterGnipRemote
  include Remotus::Remote
  attr_reader :rules_client, :stream_client

  def initialize
    @rules_client = Remotus::RemoteGnip.rules_client
    p @rules_client
    @stream_client = Remotus::RemoteGnip.stream_client
    p @stream_client
  end

  def stream
    @stream_client.stream do |status|
      GnipStreamWorker.perform_async(JSON.parse(status))
    end
  end

  def build_rules
    build_rules_queries
    @rules.each do |rule|
      p rule[:tag]
      p @rules_client
      @rules_client.add_rule(rule)
    end
  end

  private
  def build_rules_queries
    @searches = Search.all
    @rules = []
    @searches.each do |search|
      search.account.geolocations.each do |location| 
        @rules << {value: "#{search.query} point_radius:[#{location.longitude} #{location.latitude} #{distance(location.radius)}]", tag: "#{search.id}:#{location.id}"}
      end
    end
  end

  def distance(radius)
    if radius > 25
      "25mi"
    else
      "#{radius}mi"
    end
  end
end
