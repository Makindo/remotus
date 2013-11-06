class Geolocation < ActiveRecord::Base
  include Remotus::Data
  include Remotus::Provider

  belongs_to :person, touch: true
  belongs_to :source, polymorphic: true

  validates_with GeolocationValidator

  def self.complete
    where do
      city.not_eq(nil) & state.not_eq(nil) & zip.not_eq(nil) & country.not_eq(nil)
    end
  end

  def self.enough
    where { city.not_eq(nil) & state.not_eq(nil) }
  end

  def self.barely
    where { state.not_eq(nil) | (zip.not_eq(nil) | country.not_eq(nil)) }
  end

  def self.clone_geo(geolocation)
    new_geo = Geolocation.new
    new_geo.update_from_geocoder_result(geolocation)
    new_geo
  end

  def fetch_data
    FetchGeolocationWorker.perform_async(id)
  end

  def postal_code
    zip
  end

  def update_from_geocoder_result(result)
    self.city = result.city
    self.state = result.state
    self.latitude = result.latitude
    self.longitude = result.longitude
    self.country = result.country
    self.zip = result.postal_code
    self.data = result.data || result
    result.present?
  end
end
