class TwitterStreamResultsForm
  attr_reader :search
  attr_reader :statuses
  attr_reader :profiles

  def initialize(search, status)
    @search = search
    result = TwitterSearchDenormalizer.new(status).to_hash
    
    @status = TwitterStatus.new(result[:status]).tap do |status| 
      status.searches << @search
      status.profile = TwitterProfile.new(result[:profile])
      status.profile.statuses << status
    end
  end

  def valid?
    @status.profile.valid? && @status.valid?
  end

  def save
    @status.profile.save
    @status.save
  end
end
