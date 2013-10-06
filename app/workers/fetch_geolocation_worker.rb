class FetchGeolocationWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :geolocations

  def perform(id)
    @resource = Geolocation.find(id)
    @resource.update_attributes(remote_class.new(@resource.external_id).record)
  end
end
