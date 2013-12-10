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
    warn "initialized twitter results form with status: #{@status.inspect}"
    warn "initialized twitter results form with profile: #{@profile.inspect}"
    warn "valid? #{valid?}"
  end

  def valid?
    @status.valid? && @profile.valid?
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
