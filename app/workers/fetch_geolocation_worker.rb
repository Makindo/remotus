class FetchGeolocationWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :geolocations

  def perform(id)
    @resource = Geolocation.find(id)
    query = @resource.city || ""
    @result = Geocoder.search(query).first
    @resource.update_from_geocoder_result(@result)
  end
end
