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
end
