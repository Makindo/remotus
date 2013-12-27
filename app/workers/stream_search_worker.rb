class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream, backtrace: true

  #filtering and data creation to come
  def perform(status, search_id)
    begin
      @search = Search.find(search_id)
      @account = @search.account
    
      @result = TwitterStreamResultsForm.new(@search, status)
      @result.status.geocode
      has_a_close_geolocation = catch(:close_enough) do
        @account.geolocations.each do |geo| 
          if @result.status.distance_to(geo.city) < geo.radius
            throw(:close_enough, true)
          end
        end
      end
      if @result.valid? && has_a_close_geolocation
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
    end
  end
end
