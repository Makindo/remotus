class TwitterStreamDenormalizer
  attr_reader :profile, :status

  def initialize(result)
    @result = result.to_hash
    @profile = TwitterProfileDenormalizer.new(@result.delete(:user) || {})
    @status = TwitterStatusDenormalizer.new(@result)
  end

  def to_hash
    {
     status: @status.to_hash,
     profile: @profile.to_hash
    }
  end
end
