class TwitterStreamResultsForm
  attr_reader :search
  attr_reader :status
  attr_reader :profile

  def initialize(search, status)
      @search = search
      result = TwitterStreamDenormalizer.new(status).to_hash
      raise "TwitterStreamResultsForm failure with denormalizer, blank form" if result.blank?
    
      @status = TwitterStatus.new(result[:status])
      raise "TwitterStreamResultsForm failure with status creation" if @status.blank?
      @status.searches << @search
      @status.profile = TwitterProfile.new(result[:profile])
      @profile = @status.profile
      raise "TwitterStreamResultsForm failure with profile creation" if @profile.blank? || @status.profile.blank?
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
