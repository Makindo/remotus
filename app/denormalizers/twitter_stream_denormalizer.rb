class TwitterStreamDenormalizer
  attr_reader :profile, :status

  def initialize(result)
    @result = result.to_hash
    @result.symbolize_keys!
    warn "before profile is removed: #{@result.inspect}"
    @profile = TwitterProfileDenormalizer.new(@result.delete(:user) || {})
    warn "after profile is removed: #{@result.inspect}"
    @status = TwitterStatusDenormalizer.new(@result)
  end

  def to_hash
    {
     status: @status.to_hash,
     profile: @profile.to_hash
    }
  end
end
