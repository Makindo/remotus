class TwitterStatusesLocation < Geolocation
  PROVIDER = "twitter_statuses"
  def self.clone_geo(geolocation)
    new_geo = TwitterStatusesLocation.new
    new_geo.update_from_geocoder_result(geolocation) if geolocation.present?
    new_geo
  end
end
