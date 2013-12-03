class TwitterStreamRemote
  include Remotus::Remote
  include Remotus::RemoteTwitterStream

  def initialize
    @queries = Status.all.map(&:query.downcase)
    @queries_words = []
    @queries.each { |query| @queries_words << query.split(' ') }

    @location_query = Array.new
    Geolocation.where(type: "TwitterStreamLocation").pluck(:longitude, :latitude).each do |geo| 
      @location_query << geo[0] - 1 << geo[1] -1 << geo[0] + 1 << geo[1] + 1 
    end
    
    Remotus::RemoteTwitterStream.client.locations(@location_query) do |status| 
      SearchStreamWorker.perform_async(status.id) if match_search?(status.text)
    end
  end

  def match_search?(text)
    text = text.downcase
    @queries_words.each do |query|
      result = true
      query.each do |word| 
        if test.include?(word) then true else result = false end
      end
      return result if result
    end
  end
end
