class GnipStreamWorker
  include Sidekiq::Worker
  sidekiq_options queue: :gnip_stream, backtrace: true

  def perform(status)
    begin
      @result = GnipTwitterDenormalizer.new(status)
      @form = GnipTwitterStreamResultsForm.new(status)
                  
      if @form.valid?
        @form.save
        @form.searches_ids.each { |search_id| UpdateSearchesStatusesCountWorker.perform_async(search_id)}
        @form.accounts_ids.each { |account_id| FetchPersonWorker.perform_async(@form.profile.id, account_id) }
        ScoreStatusWorker.perform_async(@form.status.id)
      end
    end
  end
end
