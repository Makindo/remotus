class GnipTwitterProfileDenormalizer
  KEYS = [:id, :name, :screen_name, :location]

  def initialize(profile)
    @profile_data = profile.to_hash
    @profile_data.deep_symbolize_keys!
    @location_data = @profile_data[:location]
  end

  def to_hash
    {
     external_id: @profile_data[:id].split(':').last,
     name: @profile_data[:displayName],
     username: @profile_data[:preferredUsername],
     location: @location_data[:displayName],
     data: {profile: @profile_data, location: @loation_data},
     type: "TwitterProfile"
    }
  end
end
