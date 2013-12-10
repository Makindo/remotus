class TwitterProfileDenormalizer < Remotus::Denormalizer
  KEYS = [:id, :name, :screen_name, :location]

  def initialize(profile)
    @data = profile.to_hash || @data = {:id => nil, :screen_name => nil, :location => nil}
    @data.symbolize_keys!
  end

  def to_hash
    {
      external_id: @data[:id].to_s,
      name: @data[:name],
      username: @data[:screen_name],
      location: @data[:location],
      data: @data,
      type: "TwitterProfile"
    }
  end
end
