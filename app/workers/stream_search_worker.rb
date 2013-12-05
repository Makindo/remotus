class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream

  #filtering and data creation to come
  def perform(status, search_id)
    warn("search id: #{search_id} matched status: #{status["text"]}")
  end
end
