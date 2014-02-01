class GnipTwitterDenormalizer
  attr_reader :profile, :status

  def initialize(result)
    @result = result.deep_symbolize_keys!
    @profile = GnipTwitterProfileDenormalizer.new(@result[:actor], @result[:actor][:location])
    @status = GnipTwitterStatusDenormalizer.new(@result)
  end

  def to_hash
    {
     status: @status.to_hash,
     profile: @profile.to_hash
    }
  end
end
