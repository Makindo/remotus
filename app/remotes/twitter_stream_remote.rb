class TwitterStreamRemote
  include Remotus::Remote
  include Remotus::RemoteTwitterStream

  def initialize
    puts "Creating new stream remote"
    @queries = Search.where(active: true).pluck(:id, :query.downcase)
    @regexs = Hash.new
    @queries.each do |query| 
      @regexs[query[0]] = Regexp.new(query[1].gsub(/[a-z]+/, '(\&)').gsub(/ /, " (.*)").gsub(/^|$/, "(.*)"))
    end
    puts "finished creating #{@regexs.size} search queries"

    @location_query = Array.new
    Geolocation.where(type: "TwitterStreamLocation").pluck(:longitude, :latitude).each do |geo| 
      @location_query << geo[0] - 1 << geo[1] -1 << geo[0] + 1 << geo[1] + 1 
    end
    puts "finished creating location query"
  end

  def client
    puts "Starting stream with location query: #{@location_query}"
    Remotus::RemoteTwitterStream.client.locations(@location_query) do |status| 
      if match_search?(status.text)
        StreamSearchWorker.perform_async(status, match_search?(status.text)) 
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
