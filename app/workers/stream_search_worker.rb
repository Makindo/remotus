class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream, backtrace: true

  #filtering and data creation to come
  def perform(status, search_id)
    warn "Starting Worker"
    @search = Search.find(search_id)
    
    @result = TwitterStreamResultsForm.new(@search, status)
    warn("results form back")
    if @result.valid?
      @result.save
      warn "Updating search_statuses_counts for search_id: #{@search.id}"
      UpdateSearchesStatusesCountWorker.perform_async(@search.id)
      warn "Creating person for profile_id: #{@result.profile.id}"
      FetchPersonWorker.perform_async(@result.profile.id)
    else
      warn "#{@result.errors}"
    end
  end
end
