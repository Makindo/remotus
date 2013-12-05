class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream, backtrace: true

  #filtering and data creation to come
  def perform(status, search_id)
    @search = Search.find(search_id)
    
    @result = TwitterStreamResultsForm.new(@search, status)
    @result.save if @result.valid?
  end
end
