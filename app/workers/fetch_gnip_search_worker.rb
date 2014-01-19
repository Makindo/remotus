class FetchGnipSearchWorker
  include Sidekiq::Worker

  sidekiq_options queue: :searches, retry: 2

  def perform(id)
    begin
      @client = TwitterGnipRemote.new
      @search = Search.find(id)
      @client.search(@search.query, @search.id)
    end
  end
end
