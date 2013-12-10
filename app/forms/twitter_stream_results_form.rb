class TwitterStreamResultsForm
  attr_reader :search
  attr_reader :status
  attr_reader :profile

  def initialize(search, status)
    @search = search
    result = TwitterStreamDenormalizer.new(status).to_hash
    
    @status = TwitterStatus.new(result[:status])
    @status.searches << @search
    @status.profile = TwitterProfile.new(result[:profile])
    @profile = @status.profile
    @status.profile.statuses << @status
  end

  def valid?
    @search.valid? && @status.valid?
  end

  def errors
    Array.new << @status.errors << @profile.errors << @search.errors
  end

  def save
    @profile.save
    @status.profile = @profile
    @status.save
  end
end
