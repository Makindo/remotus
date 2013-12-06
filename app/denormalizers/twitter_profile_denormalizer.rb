class TwitterProfileDenormalizer < Remotus::Denormalizer
  KEYS = [:id_str, :name, :screen_name, :location]

  def initialize(profile)
    @data = profile.to_hash
  end

  def to_hash
    {
      external_id: @data["id_str"],
      name: @data["name"],
      username: @data["screen_name"],
      location: @data["location"],
      data: @data,
      type: "TwitterProfile"
    }
  end
end
