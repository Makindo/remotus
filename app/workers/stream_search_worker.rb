class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream, backtrace: true

  #filtering and data creation to come
  def perform(status, search_id)
    @search = Search.find(search_id)
    
    @result = TwitterStreamResultsForm.new(@search, status)
    if @result.valid?
      @result.save
      warn "Updating search_statuses_counts for search_id: #{@search.id}"
      UpdateSearchesStatusesCountWorker.perform_async(@search.id)
      warn "Creating person for profile_id: #{@result.profile.id}"
      FetchPersonWorker.perform_async(@result.profile.id)
    else
      warn "StreamSearchWorker errors:"
      @result.errors.each_full{ |msg| warn "#{msg}" }
    end
  end
end
