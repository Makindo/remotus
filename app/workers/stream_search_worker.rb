class StreamSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :twitter_stream, backtrace: true

  #filtering and data creation to come
  def perform(status, search_id, account_id)
    begin
      @search = Search.find(search_id)
    
      @result = TwitterStreamResultsForm.new(@search, status)
      if @result.valid?
        @result.save
        UpdateSearchesStatusesCountWorker.perform_async(@search.id)
        FetchPersonWorker.perform_async(@result.profile.id, account_id)
      else
        warn "StreamSearchWorker errors:"
        @result.errors.each { |errors| errors.full_messages { |msg| warn "#{msg}"  } }
      end
    rescue ActiveRecord::RecordNotUnique
      warn "external_id already exists in system."
    end
  end
end
