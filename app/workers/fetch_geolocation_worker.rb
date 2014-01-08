class FetchGeolocationWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :geolocations

  def perform(id)
    @geolocation = Geolocation.find(id)
    raise "could not find geolocation" unless @geolocation.present?

    raise "geolocation did not have a city/stante" unless @geolocation.city.present? && @geolocation.state.present?

    query = "#{@geolocation.city}, #{@geolocation.state}"

    @result = Geocoder.search(query).first
    raise "could not find result" unless @result.present?

    @geolocation.update_from_geocoder_result(@result)
    @geolocation.save if @geolocation.valid?
  end
end
