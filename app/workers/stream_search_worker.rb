class StreamSearchWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: :twitter_stream

  def perform(status_text)
    @queries = Search.map(&:query.to_lower)

  end
 end
