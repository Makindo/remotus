class Geolocation < ActiveRecord::Base
  include Remote::Data

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

  def fetch_data
    FetchGeolocationWorker.perform_async(id)
  end
end
