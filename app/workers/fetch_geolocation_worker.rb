class FetchGeolocationWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :geolocations

  def perform(id)
    @geolocation = Geolocation.find(id)
    raise "could not find geolocation" unless @geolocation.present?

    query = @geolocation.city
    raise "geolocation did not have a city" unless query.present?

    @result = Geocoder.search(query).first
    @geolocation.update_from_geocoder_result(@result)
  end
end
