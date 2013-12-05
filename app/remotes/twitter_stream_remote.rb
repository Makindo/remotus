class TwitterStreamRemote
  include Remotus::Remote
  include Remotus::RemoteTwitterStream

  def initialize
    puts "Creating new stream remote"
    @queries = Search.pluck(:id, :query.downcase)
    @regexs = Hash.new
    @queries.each do |query| 
      @regexs[query[0]] = Regexp.new(query[1].gsub(/[a-z]+/, '(\&)').gsub(/ |$|^/, "(.*)"))
    end
    puts "finished creating search queries"

    @location_query = Array.new
    Geolocation.where(type: "TwitterStreamLocation").pluck(:longitude, :latitude).each do |geo| 
      @location_query << geo[0] - 1 << geo[1] -1 << geo[0] + 1 << geo[1] + 1 
    end
    puts "finished creating location query"
  end

  def client
    puts "starting with client with location query: #{@location_query}"
    Remotus::RemoteTwitterStream.client.locations(@location_query) do |status| 
      if match_search?(status.text)
        puts "Sending to SearchStreamWoker"
        StreamSearchWorker.perform_async(status, match_search?(status.text)) 
      end
    end
  end

  def daemon
    Remotus::RemoteTwitterStream.daemon.locations(@location_query) do |status| 
      StreamSearchWorker.perform_async(status, match_search?(status.text)) if match_search?(status.text)
    end
  end

  def test_client
    start_time = Time.now
    status_count = 0
    matched_status_count = 0
    begin
    puts "starting client with the following location query: #{@location_query}"
    Remotus::RemoteTwitterStream.client.locations(@location_query) do |status| 
      puts "#{status.text}"
      status_count += 1
      matched_status_count += 1 if match_search?(status.text)
    end
    ensure
      puts "there were #{status_count} statuses and #{matched_status_count} matched in #{Time.now - start_time}"
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
