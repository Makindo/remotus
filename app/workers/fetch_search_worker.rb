class FetchSearchWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :searches

  def perform(id)
    @resource = Search.find(id)
    unless @resource.geolocations.blank?
      @resource.geolocations.each do |geolocation|
        records(geolocation.id).save
      end
    else
      records.save
    end
  end

  private

  def records(geolocation_id = nil)
    form_class.new(@resource, remote_class.new(@resource.query, geolocation_id).records)
  end

  def form_class
    "#{@resource.type}ResultsForm".camelcase.constantize
  end
end
