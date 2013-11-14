class PersonGeolocation < Geolocation
  PROVIDER = "person_geolocation"
  def self.clone_geo(geolocation)
    new_geo = PersonGeolocation.new
    new_geo.update_from_geocoder_result(geolocation)
    new_geo
  end
end
