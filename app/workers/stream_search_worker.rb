class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream

  #filtering and data creation to come
end
