class StreetAddressLocation < Geolocation
  PROVIDER = "street_address_location"

  validates_uniqueness_of :source_id, :scope => [:source_type]
  validates_uniqueness_of :person_id
  def self.clone_geo(geolocation)
    new_geo = StreetAddressLocation.new
    new_geo.update_from_geocoder_result(geolocation) 
    new_geo
  end
end
