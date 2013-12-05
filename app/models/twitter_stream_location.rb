class TwitterStreamLocation < Geolocation
  PROVIDER = "twitter_stream_location"
  def self.clone(geolocation)
    new_geo = TwitterStreamLocation.new
    new_geo.update_from_geocoder_result(geolocation)
    new_geo
  end
end
