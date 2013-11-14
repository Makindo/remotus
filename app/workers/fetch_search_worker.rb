class FetchSearchWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :searches

  def perform(id)
    @resource = Search.find(id)
    if @resource.present? &&  @resource.active?
      unless @resource.geolocations.blank?
        @resource.geolocations.find_each do |geolocation|
          records(geolocation.id).save if records.valid?
        end
      end
    end
  end

  private

  def records(geolocation_id = nil)
    form_class.new(@resource, remote_class.new(@resource.query, geolocation_id).records, geolocation_id)
  end

  def form_class
    "#{@resource.type}ResultsForm".camelcase.constantize
  end
end
