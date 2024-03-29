class FetchSearchWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :searches, retry: 2

  def perform(id)
    begin
      @resource = Search.find(id)
      raise "no search found" unless @resource.present?

      @geolocations = @resource.account.geolocations || []
      warn "running search #{@resource.query}, with geolocations: #{@geolocations.pluck(:latitude, :longitude)}"
      
      @geolocations.each do |geolocation| 
        records(geolocation.id).save
      end

      rescue ActiveRecord::RecordNotUnique
        warn "status already in db"
    end
  end

  private

  def records(geolocation_id)
    form_class.new(@resource, remote_class.new(@resource.query, geolocation_id).records, geolocation_id)
  end

  def form_class
    "#{@resource.type}ResultsForm".camelcase.constantize
  end
end
