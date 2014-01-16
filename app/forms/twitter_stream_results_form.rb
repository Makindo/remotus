class TwitterStreamResultsForm
  attr_reader :search
  attr_reader :status
  attr_reader :profile

  def initialize(search, status)
      @search = search
      result = TwitterStreamDenormalizer.new(status).to_hash
      raise "TwitterStreamResultsForm failure with denormalizer, blank form" if result.blank?
    
      @status = twitter_status(result)
      raise "TwitterStreamResultsForm failure with status creation" if @status.blank?
      @status.searches << @search
      @status.profile = twitter_profile(result)
      @profile = @status.profile
      raise "TwitterStreamResultsForm failure with profile creation" if @profile.blank? || @status.profile.blank?
      raise "Tyler Evan's profile @profile: #{@profile.id} @status.profile #{@status.profile.id}" if @profile.id == 136591 || @status.profile.id == 136591
  end

  def valid?
    @status.valid? && @profile.valid?
  end

  def errors
    Array.new << @status.errors << @profile.errors << @search.errors
  end

  def save
    @status.profile = @profile
    @profile.statuses << @status
    @status.save
    @profile.save
  end

  def twitter_profile(result)
    TwitterProfile.find_by_external_id(result[:profile][:external_id]) || TwitterProfile.new(result[:profile])
  end

  def twitter_status(result)
    TwitterStatus.find_by_external_id(result[:status][:external_id]) || TwitterStatus.new(result[:status])
  end
end
