class TwitterProfileLocation < Geolocation
  PROVIDER = "twitter_profile"
  def self.clone_geo(geolocation)
    new_geo = TwitterProfileLocation.new
    new_geo.update_from_geocoder_result(geolocation)
    new_geo
  end
end
