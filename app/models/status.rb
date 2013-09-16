class Status < ActiveRecord::Base
  include Remote::Data
  include Remote::External

  belongs_to :profile
  has_and_belongs_to_many :searches
  has_one :geolocation
  has_one :vote

  validates_with StatusValidator

  def fetch_data
    FetchStatusDataWorker.perform_async(id)
  end

  def has_location?
    latitude.present? && longitude.present?
  end

  def to_geolocation
    GeolocationFacade.new([latitude, longitude]).geolocation
  end

  private

  def generate_geolocation
    if profile.person.present? && has_location?
      FetchGeolocationWorker.perform_async(id)
    end
  end
end
