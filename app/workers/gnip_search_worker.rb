class GnipSearchWorker
  include Sidekiq::Worker
  sidekiq_options queue: :gnip_stream, backtrace: true

  def peform(status, search_id)
    begin
      @form = GnipTwitterSearchResultsForm.new(status, search_id)
      if @form.valid?
        @form.save
        UpdateSearchesStatusesCountWorker.perform_async(search_id)
        FetchPersonWorker.perform_async(@form.profile.id, @form.search.account_id)
        ScoreStatusWorker.perform_async(@form.status.id)
      end
    end
  end
end
