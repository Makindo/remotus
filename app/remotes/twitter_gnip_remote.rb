class TwitterGnipRemote
  include Remotus::Remote
  attr_reader :rules_client, :stream_client

  def initialize
    @rules_client = Remotus::RemoteGnip.rules_client
    @stream_client = Remotus::RemoteGnip.stream_client
    @search_client = Remotus::RemoteGnip.search_client
  end

  def stream
    @stream_client.stream do |status|
      GnipStreamWorker.perform_async(JSON.parse(status))
    end
  end

  def search(query, search_id, options = {})
    @search_results = @search_client.twitter_search(query, options)
    @search_results.each { |result| GnipSearchWorker.perform_async(JSON.parse(result), search_id) }
  end

  def build_rules
    build_rules_queries
    @rules.each do |rule|
      p rule[:tag]
      @rules_client.add_rule(rule)
    end
  end

  private
  def build_rules_queries
    @searches = TwitterStreamSearch.all
    @rules = []
    @searches.each do |search|
      search.account.geolocations.each do |location| 
        @rules << {value: "#{search.query} point_radius:[#{location.longitude} #{location.latitude} #{distance(location.radius)}]", tag: "#{search.id}:#{search.account_id}"}
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
