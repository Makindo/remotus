class TwitterStreamDenormalizer
  attr_reader :profile, :status

  def initialize(result)
    warn("starting denorm")
    @result = result.to_hash
    warn("profile denorm")
    @profile = TwitterProfileDenormalizer.new(@result.delete(:user) || {})
    warn("status denorm")
    @status = TwitterStatusDenormalizer.new(@result)
  end

  def to_hash
    warn("converting denorm to hash")
    {
     status: @status.to_hash,
     profile: @profile.to_hash
    }
  end
end
