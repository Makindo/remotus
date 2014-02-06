class StreetAddressLocation < Geolocation
  PROVIDER = "street_address_location"
  def self.clone_geo(geolocation)
    new_geo = StreetAddressLocation.new
    new_geo.update_from_geocoder_result(geolocation) 
    new_geo
  end
end
