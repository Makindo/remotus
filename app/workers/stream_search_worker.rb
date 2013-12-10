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
      UpdateSearchesStatusesCountWorker.perform_async(@search.id)
      FetchPersonWorker.perform_async(@result.profile.id)
    end
  end
end
