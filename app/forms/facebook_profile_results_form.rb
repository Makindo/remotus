class FacebookProfileResultsForm
  attr_reader :profile
  def initialize(profile)
    result = FacebookProfileDenormalizer.new(profile).to_hash
    @profile = FacebookProfile.new(result[:profile])
  end

  def valid?
    @profile.valid?
  end

  def errors
    @profile.map(&:errors)
  end

  def save
    @profile.save
  end
end
