class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream, backtrace: true

  #filtering and data creation to come
  def perform(status, search_id)
    @search = Search.find(search_id)
    
    @result = TwitterStreamResultsForm.new(@search, status)
    if @result.valid?
      @result.save
      UpdateSearchesStatusesCountWorker.perform_async(@search.id)
      FetchPersonWorker.perform_async(@result.profile.id)
    else
      warn "StreamSearchWorker errors:"
      @result.errors.each { |errors| errors.full_messages { |msg| warn "#{msg}"  } }
    end
  end
end
