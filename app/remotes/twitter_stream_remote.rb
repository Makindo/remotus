class TwitterStreamRemote
  include Remotus::Remote
  include Remotus::RemoteTwitterStream

  def initialize(location_query)
    warn "new twitter stream remote"
    @location_query = location_query
    @queries = TwitterStreamSearch.where(active: true).map(&:query_regex)
    @regexs = Hash.new
    @queries.each do |query| 
      @regexs[query[0]] = query[1]
    end
  end

  def client
    warn "Starting stream with locations: #{@location_query}"
    Remotus::RemoteTwitterStream.client.locations(@location_query) do |status| 
      matched = match_searches(status.text)
      matched.each do |search_id| 
        warn "matched some searches"
        StreamSearchWorker.perform_async(status, search_id)
        IncreaseDailyStatsWorker.perform_async("twitter_stream", "matched")
      end
    end
  end

  def daemon
    Remotus::RemoteTwitterStream.daemon.locations(@location_query) do |status| 
      StreamSearchWorker.perform_async(status, match_search?(status.text)) if match_search?(status.text)
    end
  end

  def match_searches(text)
    matching_regexs = []
    @regexs.each do |id, regex|
      if !!(text.match(regex))
        matching_regexs << id
      end
    end
    matching_regexs
  end
end
