class TwitterStreamRemote
  include Remotus::Remote
  include Remotus::RemoteTwitterStream

  def initialize(location_query, account_id)
    @location_query = location_query
    @account_id = account_id
    @queries = Search.all.map(&:query_regex)
    @regexs = Hash.new
    @queries.each do |query| 
      @regexs[query[0]] = query[1]
    end
  end

  def client
    Remotus::RemoteTwitterStream.client.locations(@location_query) do |status| 
      if match_search?(status.text)
        StreamSearchWorker.perform_async(status, match_search?(status.text), @account_id) 
      end
    end
  end

  def daemon
    Remotus::RemoteTwitterStream.daemon.locations(@location_query) do |status| 
      StreamSearchWorker.perform_async(status, match_search?(status.text)) if match_search?(status.text)
    end
  end

  def match_search?(text)
    @regexs.each do |id, regex|
      if !!(text.match(regex))
        return id
      end
    end
    false
  end
end
