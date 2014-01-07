module StreamErrors
  class NoSearchError < StandardError; end
  class ResultsFormError < StandardError; end
  class NotSaved < StandardError; end
  class NotGeocoded < StandardError; end
  class NotInGeoArea < StandardError; end
end

class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream, backtrace: true

  #filtering and data creation to come
  def perform(status, search_id)
    begin
      @search = Search.find(search_id)
      raise StreamErrors::NoSearchError if @search.blank?

      @account = @search.account
    
      @result = TwitterStreamResultsForm.new(@search, status)
      raise StreamErrors::ResultsFormError if @result.blank?
      @result.status.geocode

      raise StreamErrors::NotSaved  if @result.status.blank?
      raise StreamErrors::NotGeocoded unless @result.status.respond_to?(:distance_to)

      has_a_close_geolocation = catch(:close_enough) do
        @account.geolocations.each do |geo| 
          geo_distance = @result.status.distance_to(geo.city) || 1/0.0
          warn "geo_distance could not be computed" if geo_distance == 1/0.0
          if geo_distance < geo.radius
            throw(:close_enough, true)
          end
        end
        false
      end

      raise StreamErrors::NotInGeoArea unless has_a_close_geolocation

      if @result.valid?
        @result.save
        UpdateSearchesStatusesCountWorker.perform_async(@search.id)
        FetchPersonWorker.perform_async(@result.profile.id, @account.id)
        ScoreStatusWorker.perform_async(@result.status.id)
      else
        warn "StreamSearchWorker errors:"
        @result.errors.each { |errors| errors.full_messages { |msg| warn "#{msg}"  } }
      end
    rescue ActiveRecord::RecordNotUnique
      warn "external_id already exists in system."
    rescue StreamErrors::NotInGeoArea
      warn "status was not in a geolocated area: #{@result.profile.location}"
    end
  end
end
