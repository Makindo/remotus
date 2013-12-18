class TwitterStreamRemote
  include Remotus::Remote
  include Remotus::RemoteTwitterStream

  def initialize(location_query)
    @location_query = location_query
    @queries = Search.where(active: true).map(&:query_regex)
    @regexs = Hash.new
    @queries.each do |query| 
      @regexs[query[0]] = query[1]
    end
  end

  def client
    Remotus::RemoteTwitterStream.client.locations(@location_query) do |status| 
      warn "Starting stream with locations: #{@location_query}"
      matched = match_searches(status.text)
      unless matched.blank?
        matched_searches.each do |search_id| 
          StreamSearchWorker.perform_async(status, search_id)
        end
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
