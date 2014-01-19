class GnipTwitterStreamResultsForm
  attr_reader :searches_ids
  attr_reader :accounts_ids
  attr_reader :status
  attr_reader :profile

  def initialize(result)
    @result = result.symbolize_keys!
    @denorm = GnipTwitterDenormalizer.new(result).to_hash
    @status = twitter_status
    @profile = twitter_profile
    @searches = find_searches
  end


  def valid?
    @status.valid? && @profile.valid?
  end

  def save
    @status.profile = @profile
    @profile.statuses << @status
    @searches.each do |search| 
      search.statuses << @status
      @status.searches << search
      search.save
    end
    @status.save
    @profile.save
  end

  def twitter_status
    TwitterStatus.find_by_external_id(@denorm[:status][:external_id]) || TwitterStatus.new(@denorm[:status])
  end

  def twitter_profile
    TwitterProfile.find_by_external_id(@denorm[:profile][:external_id]) || TwitterProfile.new(@denorm[:profile])
  end

  def matching_tags
    temp_array = []
    p "starting matched_tags"
    @result[:gnip][:matching_rules].each do |rule| 
      temp_array << rule["tag"].split(':')
    end
    temp_array
  end

  def searches_ids
    temp_array = []
    p "starting statuses_ids"
    matching_tags.each do |tag|
      temp_array << tag.first
    end
    temp_array
  end

  def accounts_ids
    temp_array = []
    matching_tags.each do |tag|
      temp_array << tag.first
    end
    temp_array
  end

  def find_searches
    temp_array = []
    p "starting find searches"
    searches_ids.each do |search_id| 
      temp_array << Search.find(status_id)
    end
    temp_array
  end
end
