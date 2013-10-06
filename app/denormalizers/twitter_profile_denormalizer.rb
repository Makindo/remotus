class TwitterProfileDenormalizer < Remotus::Denormalizer
  KEYS = [:id_str, :name, :screen_name, :location]

  def initialize(profile)
    @data = profile.to_hash
  end

  def to_hash
    {
      external_id: attributes.id_str,
      name: attributes.name,
      username: attributes.screen_name,
      location: attributes.location,
      data: @data,
      type: "TwitterProfile"
    }
  end
end
