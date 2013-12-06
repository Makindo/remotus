class TwitterStreamResultsForm
  attr_reader :search
  attr_reader :status
  attr_reader :profile

  def initialize(search, status)
    @search = search
    result = TwitterStreamDenormalizer.new(status).to_hash
    
    @status = TwitterStatus.new(result[:status])
    @status.searches << @search
    @status.profile = TwitterProfile.first_or_create(result[:profile])
    @status.profile.save
    @status.profile.statuses << @status
  end

  def valid?
    @search.valid? && @status.valid?
  end

  def save
    @status.profile.save 
    @status.save
  end
end
